
_pipenv_scripts_completion() {
    local cur prev cword
    _get_comp_words_by_ref -n : cur prev cword

    if [ "${prev}" != "run" ]; then
        local IFS=$'\t'
        COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   _PIPENV_COMPLETE=complete-bash $1 ) )
        return 0
    fi
    PIPFILE="$(pwd)/Pipfile"
    if [ ! -e PIPFILE ]; then
        return
    fi
    
    isScript=false
    scripts=""
    while read name cmd;
    do
        if ${isScript} ; then
            scripts="${scripts}\n${name}"
        fi
        if [ "$name" == "[scripts]" ]; then
            isScript=true
        fi
    done < ${PIPFILE}

    COMPREPLY=( $(compgen -W "$(echo -e ${scripts})" ${cur} ) )
    return 0
}

complete -F _pipenv_scripts_completion pipenv 