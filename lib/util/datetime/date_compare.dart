bool isSameDay(DateTime lhs, DateTime rhs) =>
    lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day;

bool isSameMonth(DateTime lhs, DateTime rhs) =>
    lhs.year == rhs.year && lhs.month == rhs.month;
