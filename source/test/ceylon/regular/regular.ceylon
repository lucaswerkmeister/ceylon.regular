import ceylon.regular { any, lit, not }
import ceylon.test { test }

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
    assert(exists k = exp.match("abcd"), k == 4);
}
