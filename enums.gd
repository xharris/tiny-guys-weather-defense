class_name Enums

enum Compare {EQ, NE, GT, GTE, LT, LTE}

static func compare(cmp:Compare, a, b) -> bool:
    match cmp:
        Compare.EQ:
            return a == b
        Compare.NE:
            return a != b
        Compare.GT:
            return a > b
        Compare.GTE:
            return a >= b
        Compare.LT:
            return a < b
        Compare.LTE:
            return a <= b
    return false

enum Operation {ADD, SUB, MULT, DIV}

static func operate(oper: Operation, a: Variant, b: Variant) -> Variant:
    match oper:
        Operation.ADD:
            return a + b
        Operation.SUB:
            return a - b
        Operation.MULT:
            return a * b
        Operation.DIV:
            return a / b if b != 0 else 0
    return a
