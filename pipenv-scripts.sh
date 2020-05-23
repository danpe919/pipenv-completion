
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

    SECTION_END='^[ \t]*\[[^]]+\][ \t]*$'
    commands=$(cat ${PIPFILE} | sed -nre "/^[ \t]*\[scripts\][ \t]*$/ {p;:LOOP;n;/${SECTION_END}/Q;p;b LOOP}" | sed -e "/scripts/d" | awk -F " " '{printf $1 " " }')
    
    COMPREPLY=( $(compgen -W "$(echo -e ${commands})" ${cur} ) )
    return 0
}

complete -F _pipenv_scripts_completion pipenv 
