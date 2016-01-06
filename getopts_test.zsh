#!/bin/zsh

: before
{
    source $PWD/getopts.zsh
}

describe "getopts.zsh"
    it "only bare"
        out="$(getopts beer)"
        ret=$status
        assert equal "$out" "_ beer"
        assert equal "$ret" "0"
    end

    it "bare and bare"
        expects=( "_ bar" "_ beer" )
        actuals=( "${(@f)"$(getopts bar beer)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "bare first"
        expects=( "_ beer" "foo" )
        actuals=( "${(@f)"$(getopts beer --foo)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "bare sequence"
        expects=( "_ foo" "_ bar" "_ baz" "_ quux" )
        actuals=( "${(@f)"$(getopts foo bar baz quux)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "bare does not end opts"
        expects=( "a" "b 42" "_ beer" "foo" "bar" )
        actuals=( "${(@f)"$(getopts beer -ab42 beer --foo --bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "only single"
        expects=( "f" "o" "o 42" )
        actuals=( "${(@f)"$(getopts -foo42)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "single and single"
        expects=( "a" "b" "c" "x" "y" "z" )
        actuals=( "${(@f)"$(getopts -abc -xyz)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "single and bare"
        expects=( "a" "b" "c bar" )
        actuals=( "${(@f)"$(getopts -abc bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "single and value"
        expects=( "a bar" )
        actuals=( "${(@f)"$(getopts -a bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "single w/ value and bare"
        expects=( "a" "b" "c" "./" "_ bar" )
        actuals=( "${(@f)"$(getopts -abc./ bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "single and double"
        expects=( "a" "b" "c" "foo" )
        actuals=( "${(@f)"$(getopts -abc --foo)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double"
        expects=( "foo" )
        actuals=( "${(@f)"$(getopts --foo)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double w/ value"
        expects=( "foo bar" )
        actuals=( "${(@f)"$(getopts --foo=bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double w/ nagated value"
        expects=( "foo bar !" )
        actuals=( "${(@f)"$(getopts --foo!=bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double w/ value group"
        expects=( "foo bar" "bar foo" )
        actuals=( "${(@f)"$(getopts --foo=bar --bar=foo)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double w/ value and bare"
        expects=( "foo bar" "_ beer" )
        actuals=( "${(@f)"$(getopts --foo=bar beer)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double double"
        expects=( "foo" "bar" )
        actuals=( "${(@f)"$(getopts --foo --bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double w/ inner dashes"
        expects=( "foo-bar-baz" )
        actuals=( "${(@f)"$(getopts --foo-bar-baz)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double and single"
        expects=( "foo" "a" "b" "c" )
        actuals=( "${(@f)"$(getopts --foo -abc)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "multiple double sequence"
        expects=( "foo" "bar" "secret 42" "_ baz" )
        actuals=( "${(@f)"$(getopts --foo --bar --secret=42 baz)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "single double single w/ remaining bares"
        expects=( "f" "o" "o" "bar" "b" "a" "r norf" "_ baz" "_ quux")
        actuals=( "${(@f)"$(getopts -foo --bar -bar norf baz quux)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double dash"
        expects=( "_ --foo" "_ bar" )
        actuals=( "${(@f)"$(getopts -- --foo bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "single double dash"
        expects=( "a" "_ --foo" "_ bar" )
        actuals=( "${(@f)"$(getopts -a -- --foo bar)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "bare and double dash"
        expects=( "foo bar" "_ baz" "_ foo" "_ --foo" )
        actuals=( "${(@f)"$(getopts --foo=bar baz -- foo --foo)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "long string as a value"
        expects=( "f Fee fi fo fum" )
        actuals=( "${(@f)"$(getopts -f "Fee fi fo fum")"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "single and empty string"
        expects=( "f" )
        actuals=( "${(@f)"$(getopts -f "")"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "double and empty string"
        expects=( "foo" )
        actuals=( "${(@f)"$(getopts --foo "")"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end

    it "ignore repeated options"
        expects=( "x" )
        actuals=( "${(@f)"$(getopts -xxx | xargs)"}" )
        ret=$status
        array --a $expects --b $actuals
        assert equal "$ret" "0"
    end
end
