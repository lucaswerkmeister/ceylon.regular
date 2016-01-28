import ceylon.regular { Regular, any, lazy, lit, where }
import ceylon.test { test, assertEquals, ignore }

test
shared void backtrack() {
    value exp  = lit("a").zeroPlus + lit("ab");
    assert(exp.match("aaaaaaab") exists);
}

test
shared void maybe() {
    value exp  = lit("a") + any("bcd").maybe + lit("e");
    assert(exp.match("ae") exists);
    assert(exp.match("abe") exists);
    assert(exp.match("ace") exists);
    assert(exp.match("ade") exists);
    assert(! exp.match("afe") exists);
    assert(! exp.match("abce") exists);
}

test
shared void andTest() {
    value exp = lit("abc").and(any("abcd").repeat(4));

    assert(exp.match("abca") exists);
    assert(exp.match("abcb") exists);
    assert(exp.match("abcd") exists);
    assert(! exp.match("abc") exists);
    assert(! exp.match("abdd") exists);
    assert(exists k = exp.match("abcd"), k.matched == "abcd");

    value exp2 = lit("abc").and(any("abcd").repeat(2));

    assert(exists k2 = exp2.match("abc"), k2.length == 2);
}

test
shared void orTest() {
    value exp = lit("abc").or(lit("def"));

    assert(exp.match("abc") exists);
    assert(exp.match("def") exists);
    assert(! exp.match("abf") exists);
}

test
shared void repeatTest() {
    value exp = lit("a").repeat(3, 5);

    assert(! exp.match("a") exists);
    assert(! exp.match("aa") exists);
    assert(exp.match("aaa") exists);
    assert(exp.match("aaaa") exists);
    assert(exp.match("aaaaa") exists);
    assert(exists k = exp.match("aaaaaa"), k.matched == "aaaaa");
}

test
shared void whereTest() {
    assertEquals {
        expected = lit("c").match("c");
        actual = where('c'.equals).match("c");
    };
    assertEquals {
        expected = lit("c").match("c");
        actual = where(and(Character.lowercase, Character.letter)).match("c");
    };
}

test
ignore ("unsupported")
shared void circularTestLeftRecursive() {
    Regular commaSeparatedXs() => lit("a").or(lazy(commaSeparatedXs).concat(lit(",a")));
    assert(exists m = commaSeparatedXs().match("a,a,a"), m.matched == "a,a,a");
}

test
shared void circularTestRightRecursive() {
    Regular commaSeparatedXs() => lit("a").or(lit("a,").concat(lazy(commaSeparatedXs)));
    assert(exists m = commaSeparatedXs().match("a,a,a"), m.matched == "a,a,a");
}

test
shared void circularTestParentheses() {
    Regular parentheses() => lit("(").concat(lazy(parentheses).zeroPlus).concat(lit(")"));
    String parens = "((()(())())()(((())())((()))())())";
    assert(exists m = parentheses().match(parens), m.matched == parens);
}
