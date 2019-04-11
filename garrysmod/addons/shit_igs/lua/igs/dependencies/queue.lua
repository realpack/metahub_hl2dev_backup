local Queue = {}
Queue.__index = Queue

function Queue:get()
	if self.index > self.headLength then
		self.head, self.tail = self.tail, self.head
		self.index = 1
		self.headLength = #self.head
	end

	if self.headLength == 0 then
		return
	end

	return self.head[self.index]
end

function Queue:shift() -- убирает самые ранние значения
	local value = self:get()

	self.head[self.index] = nil
	self.index = self.index + 1

	return value
end

function Queue:push(item)
	return table.insert(self.tail, item)
end

function NewQueue()
	return setmetatable({
		head = {},
		tail = {},
		index = 1,
		headLength = 0
	},Queue)
end

/*

local Q = NewQueue()
Q:push(1)
Q:push(2)
Q:push(3)
print(Q:shift())
print(Q:shift())
Q:push(4)
print(Q:get())

/*
local Q = NewQueue()
assert(Q:push(1) == 1)
assert(Q:push(3) == 2)

assert(Q:shift() == 1)
assert(Q:shift() == 3)
assert(Q:shift() == nil)

assert(Q:push(7) == 1)
assert(Q:push(9) == 2)

assert(Q:shift() == 7)
assert(Q:push(7) == 1)
assert(Q:push(8) == 2)

assert(Q:shift() == 9)
assert(Q:shift() == 7)
assert(Q:shift() == 8)
assert(Q:shift() == nil)

assert(Q:push(1) == 1)
assert(Q:push(2) == 2)
assert(Q:shift() == 1)
assert(Q:push(1) == 1)

prt(Q)
