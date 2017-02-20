defmodule Identicon do
    def say_hello(input) do
        "hello #{input}" 
        |> add_conversation
    end

    def add_conversation(input) do
        input <> ", how are you?"
    end

    def main(input) do 
        input 
        |> hash_input
        |> pick_color
        |> build_grid
        |> filter_odd_squares
    end

    def hash_input(input) do
        hex = :crypto.hash(:md5, input) 
        |> :binary.bin_to_list 

        %Identicon.Image{hex: hex} 
    end

    def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do 
        #%Identicon.Image{hex: [r, g, b | _tail]} = image 
        #[r, g, b | _tail] = hex_list 
        #[r, g, b] 

        %Identicon.Image{image |  color: {r, g, b}}
    end

    def build_grid(%Identicon.Image{hex: hex_list} = image) do 
        grid = hex_list
            |> Enum.chunk(3)
            |> Enum.map(&mirror_row/1)
            |> List.flatten 
            |> Enum.with_index 

            %Identicon.Image{image | grid: grid}

    end

    def filter_odd_squares(%Identicon.Image{grid: grid} = image) do 
        grid = Enum.filter grid, fn({element, _index}) ->
                rem(element, 2) == 0
        end 

        %Identicon.Image{image | grid: grid}

    end

    def mirror_row([first, second | _tail] = row) do 
        row ++ [second, first]
    end
end
