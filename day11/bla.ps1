


$somevar = "abc"

switch ($somevar) {
    {$_ -match '.+cd*'} {
        #do something
        break
    }

    {$_ -in @('abc','abd','abf')} {
        #do that
        break
    }

    default {
        throw "we should not be here"
        break
    }
}