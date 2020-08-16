------------------------------------------------------------------------------
-- Maethrillian library
-- Author: Sledmine
-- Version: 3.0
-- Compression, decompression and tools for data manipulation
------------------------------------------------------------------------------
local glue = require "glue"
local maethrillian = {}

--- Compress object data in the given format
---@param data table
---@param compressionList table
---@param hex boolean
---@return table
function maethrillian.compressObject(data, compressionList, hex)
    local compressedData = {}
    for property, encodedValue in pairs(data) do
        local compressionFormat = compressionList[property]
        if (compressionFormat) then
            if (hex) then
                compressedData[property] = glue.tohex(string.pack(compressionFormat, encodedValue))
            else
                compressedData[property] = string.pack(compressionFormat, encodedValue)
            end
        else
            compressedData[property] = encodedValue
        end
    end
    return compressedData
end

--- Format table into request
-- List or an Object with data, Optional the order result of the object properties
---@param data table
---@param order table
-- String with formatted data
--- @return string
function maethrillian.convertObjectToRequest(data, order)
    local requestData = {}
    for currentProperty, value in pairs(data) do
        if (order) then
            for position, propertyName in pairs(order) do
                if (currentProperty == propertyName) then
                    requestData[position] = value
                end
            end
        else
            requestData[#requestData + 1] = value
        end
    end
    return table.concat(requestData, ",")
end

--- Decompress data given an object/table and expected compression
---@param data table
---@param compressionList any
function maethrillian.decompressObject(data, compressionList)
    local dataDecompressed = {}
    for property, encodedValue in pairs(data) do

        -- Get compression format for current value
        local compressionFormat = compressionList[property]

        if (compressionFormat) then
            -- There is a compression format available
            value = string.unpack(compressionFormat, glue.fromhex(encodedValue))
        elseif (tonumber(encodedValue) ~= nil) then
            -- Convert value into number
            value = tonumber(encodedValue)
        else
            -- Value is just a string
            value = encodedValue
        end
        dataDecompressed[property] = value
    end
    return dataDecompressed
end

--- Transform request into data given string and format
---@param request string
---@param format table
function maethrillian.convertRequestToObject(request, format)
    local data = {}
    local dataRequest = glue.string.split(",", request)
    for index, value in pairs(dataRequest) do
        local propertyName = format[index]
        if (propertyName) then
            data[propertyName] = value
        end
    end
    return data
end

return maethrillian
