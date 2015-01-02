function relativeTime(now, then) {
    if (now.isSame(then)) {
        return "";
    }

    if (now.isAfter(then)) {
        var tmp = now;
        now = then;
        then = tmp;
    }

    var yDiff = then.year() - now.year();
    var mDiff = then.month() - now.month();
    var dDiff = then.date() - now.date();
    var hourDiff = then.hour() - now.hour();
    var minDiff = then.minute() - now.minute();
    var sDiff = then.second() - now.second();

    if (sDiff < 0) {
        sDiff += 60;
        minDiff--;
    }

    if (minDiff < 0) {
        minDiff += 60;
        hourDiff--;
    }

    if (hourDiff < 0) {
        hourDiff += 24;
        dDiff--;
    }

    if (dDiff < 0) {
        var daysInLastFullMonth = M.moment(then.year() + "-" + (then.month() + 1), "YYYY-MM").subtract(1, "months").daysInMonth();
        if (daysInLastFullMonth < now.date()) {
            dDiff = daysInLastFullMonth + dDiff + (now.date() - daysInLastFullMonth);
        } else {
            dDiff = daysInLastFullMonth + dDiff;
        }
        mDiff--;
    }

    if (mDiff < 0) {
        mDiff += 12;
        yDiff--;
    }

    var result = {
        years: (yDiff) ? yDiff : 0,
        months: (mDiff) ? mDiff : 0,
        days: (dDiff) ? dDiff : 0,
        hours: (hourDiff) ? hourDiff : 0,
        minutes: (minDiff) ? minDiff : 0,
        seconds: (sDiff) ? sDiff : 0
    };

    return result;
}
