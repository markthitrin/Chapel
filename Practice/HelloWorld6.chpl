config const printLocalName = true;

config const tasksPerLocale = 1;

coforall loc in Locales {
    on loc {
        coforall tid in 0..#tasksPerLocale {
            var message = "Hello World! (from ";
            if(tasksPerLocale > 1) then
                message += "task " + tid:string + " of " + tasksPerLocale:string + " on ";
            message += "locale " + here.id:string + " of " + numLocales:string;

            if printLocalName then message += " named " + loc.name;
            message += ")";
            writeln(message);
        }
    }
}