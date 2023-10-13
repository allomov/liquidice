module Liquidice
  module Transformer
    module Nodes
      class Base
        attr_reader :original_text, :children, :options

        def initialize(original_text:, children: [], options: {})
          @original_text, @children, @options = original_text, children, options

          validate!
        end

        def to_s
          raise NotImplementedError
        end

        def strict_mode?
          false
        end

        def transform!
          # do nothing
        end

        def validate!
          # do nothing
        end

        def can_be_merged?(other)
          false
        end

        @@dot_id_counter = 0

        def dot_id
          @dot_id ||= @@dot_id_counter += 1
        end

        def write_dot(io)
          io.puts "node#{dot_id} [label=\"'#{original_text}'\"];"
          children.each do |child|
            io.puts "node#{dot_id} -> node#{child.dot_id};"
            child.write_dot(io)
          end
        end

        def write_dot_file(fname)
          File.open(fname + ".dot","w") do |file|
            file.puts "digraph G {"
            write_dot(file)
            file.puts "}"
          end
        end
      end
    end
  end
end
