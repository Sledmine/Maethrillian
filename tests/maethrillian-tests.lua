------------------------------------------------------------------------------
-- Maethrillian
-- Sledmine
-- Maethrillian couple of tests
------------------------------------------------------------------------------
local lu = require "luaunit"
local glue = require "glue"
local inspect = require "inspect"

-- Modules to import
local maeth = require "maethrillian"

-- Prepare tests collection
testMaeth = {}

-- On first test run set up
function testMaeth:setUp()
    self.separator = "|"
    self.inputTable = {
        testInteger4 = 4148651965,
        testFloat = 235.66200256348,
        testNoEncodeInteger = 1024,
        testNoEncodeString = "test",
        testNoEncodeNumberString = "2048",
        testNoAllowedProperty = "data"
    }
    self.decodedTable = {
        testInteger4 = 4148651965,
        testFloat = 235.66200256348,
        testNoEncodeInteger = 1024,
        testNoEncodeString = "test",
        testNoEncodeNumberString = "2048"
    }
    self.encodedTable = {
        testInteger4 = "bd6747f7",
        testFloat = "79a96b43",
        testNoEncodeInteger = 1024,
        testNoEncodeString = "test",
        testNoEncodeNumberString = "2048"
    }
    self.tableFromRequest = {
        testInteger4 = "bd6747f7",
        testFloat = "79a96b43",
        testNoEncodeInteger = 1024,
        testNoEncodeString = "test",
        testNoEncodeNumberString = 2048
    }
    self.requestFormat = {
        {"testInteger4", "I4"},
        {"testFloat", "f"},
        {"testNoEncodeInteger"},
        {"testNoEncodeString"},
        {"testNoEncodeNumberString"}
    }
end

function testMaeth:testEncodeTable()
    local encodedTable = maeth.encodeTable(self.inputTable, self.requestFormat)
    lu.assertEquals(encodedTable, self.encodedTable, "encoded values must match", true)
end

function testMaeth:testDecodeTable()
    local decodedTable = maeth.decodeTable(self.encodedTable, self.requestFormat)
    lu.assertAlmostEquals(decodedTable.testInteger4, self.decodedTable.testInteger4, 0.00000000001,
                          "decoded testInteger4 must match")
    lu.assertAlmostEquals(decodedTable.testFloat, self.decodedTable.testFloat, 0.00000000001,
                          "decoded testInteger4 must match")
end

function testMaeth:testTableToRequestString()
    local requestString = maeth.tableToRequest(self.encodedTable, self.requestFormat, self.separator)
    local tempTable = {}
    for property, value in pairs(self.tableFromRequest) do
        for newPropertyIndex, format in pairs(self.requestFormat) do
            if (format[1] == property) then
                tempTable[newPropertyIndex] = value
            end
        end
    end
    lu.assertEquals(requestString, table.concat(tempTable, self.separator), "compression string must match",
                    true)
end

function testMaeth:testRequestToTable()
    local requestString = maeth.tableToRequest(self.encodedTable, self.requestFormat, self.separator)
    local requestTable = maeth.requestToTable(requestString, self.requestFormat, self.separator)
    lu.assertEquals(requestTable, self.tableFromRequest, "encoded values must match", true)
end

local function runTests()
    local runner = lu.LuaUnit.new()
    runner:runSuite()
end

if (not arg) then
    return runTests
else
    runTests()
end
