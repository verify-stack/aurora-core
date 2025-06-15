return { -- have a new instance every time lol
	new = function()
		local function init()
			local obj = {
				root = {},
				options = {noreduce = {}}
			}

			obj._stack = {obj.root}  
			return obj  
		end
		--
		--  This code is freely distributable under the terms of the [MIT license](LICENSE).
		--
		--@author Paul Chakravarti (paulc@passtheaardvark.com)
		--@author Manoel Campos da Silva Filho
		local tree = init()

		---Instantiates a new handler object.
		--Each instance can handle a single XML.
		--By using such a constructor, you can parse
		--multiple XML files in the same application.
		--@return the handler instance
		function tree:new()
			local obj = init()

			obj.__index = self
			setmetatable(obj, self)

			return obj
		end

		--- Recursively removes redundant vectors for nodes
		-- with single child elements
		function tree:reduce(node, key, parent)
			for k,v in pairs(node) do
				if type(v) == 'table' then
					self:reduce(v,k,node)
				end
			end
			if #node == 1 and not self.options.noreduce[key] and 
				node._attr == nil then
				parent[key] = node[1]
			end
		end

		local function convertObjectToArray(obj)
			--#obj == 0 verifies if the field is not an array
			if #obj == 0 then
				local array = {}
				table.insert(array, obj)
				return array
			end

			return obj
		end

		---Parses a start tag.
		-- @param tag a {name, attrs} table
		-- where name is the name of the tag and attrs
		-- is a table containing the atributtes of the tag
		function tree:starttag(tag)
			local node = {}
			if self.parseAttributes == true then
				node._attr=tag.attrs
			end

			--Table in the stack representing the tag being processed
			local current = self._stack[#self._stack]

			if current[tag.name] then
				local array = convertObjectToArray(current[tag.name])
				table.insert(array, node)
				current[tag.name] = array
			else
				current[tag.name] = {node}
			end

			table.insert(self._stack, node)
		end

		---Parses an end tag.
		-- @param tag a {name, attrs} table
		-- where name is the name of the tag and attrs
		-- is a table containing the atributtes of the tag
		function tree:endtag(tag, s)
			--Table in the stack representing the tag being processed
			--Table in the stack representing the containing tag of the current tag
			local prev = self._stack[#self._stack-1]
			if not prev[tag.name] then
				error("XML Error - Unmatched Tag ["..s..":"..tag.name.."]\n")
			end
			if prev == self.root then
				-- Once parsing complete, recursively reduce tree
				self:reduce(prev, nil, nil)
			end

			table.remove(self._stack)
		end

		---Parses a tag content.
		-- @param t text to process
		function tree:text(text)
			local current = self._stack[#self._stack]
			table.insert(current, text)
		end

		---Parses CDATA tag content.
		tree.cdata = tree.text
		tree.__index = tree
		return tree
	end,
}