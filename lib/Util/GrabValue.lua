return function(Table: table, Key: string | number): any
	local Value: any = Table[Key]
	Table[Key] = nil

	return Value
end