#!/usr/bin/env bash

#  (The MIT License)
#
#  Copyright (c) 2015 - 2019 Mamadou Babaei
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

#  OmniBackup
#  One Script to back them all up
#  Version 0.2.0

#  ToDo
#   * Restore script
#   * GnuPG integration
#   * SFTP and FTP support
#   * Refactoring and code clean-up
#   * Any potential bug fixes


readonly START_SECOND=${SECONDS}

readonly APP_NAME="OmniBackup"
readonly APP_VERSION_MAJOR="0"
readonly APP_VERSION_MINOR="2"
readonly APP_VERSION_PATCH="0"

readonly CONFIG_DIRS=( "~/.omnibackup" "/usr/local/etc/omnibackup" "/etc/omnibackup" "" )
CONFIG_FILE="config.json"
readonly LOCK_FILE="/var/run/omnibackup.lock"

readonly SYSLOG_TAG="BACKUP"
readonly DEBUG_TAG="DEBUG"
readonly ERROR_TAG="ERROR"
readonly FATAL_TAG="FATAL"
readonly INFO_TAG="INFO"
readonly SUCCESS_TAG="SUCCESS"
readonly TRACE_TAG="TRACE"
readonly WARNING_TAG="WARNING"

readonly E_1="1"
readonly E_2="2"
readonly E_3="3"
readonly E_4="4"
readonly E_5="5"
readonly E_6="6"
readonly E_7="7"
readonly E_8="8"
readonly E_9="9"
readonly E_1E="1e"
readonly E_2E="2e"
readonly E_3E="3e"
readonly E_4E="4e"
readonly E_5E="5e"
readonly E_6E="6e"
readonly E_7E="7e"
readonly E_8E="8e"
readonly E_9E="9e"
readonly E_128="128"
readonly E_192="192"
readonly E_256="256"
readonly E_ALNUM="alnum"
readonly E_ALPHA="alpha"
readonly E_ASTERISK="*"
readonly E_BLANK="blank"
readonly E_BZIP2="bzip2"
readonly E_CNTRL="cntrl"
readonly E_DIGIT="digit"
readonly E_ERROR="error"
readonly E_FALSE="false"
readonly E_GRAPH="graph"
readonly E_GZIP="gzip"
readonly E_LOWER="lower"
readonly E_LZMA2="lzma2"
readonly E_MD4="md4"
readonly E_MD5="md5"
readonly E_MDC2="mdc2"
readonly E_MYSQL="mysql"
readonly E_NEVER="never"
readonly E_NO="no"
readonly E_NULL="null"
readonly E_PARTIAL="partial"
readonly E_POSTGRES="postgres"
readonly E_PRINT="print"
readonly E_PUNCT="punct"
readonly E_RIPEMD160="ripemd160"
readonly E_SHA="sha"
readonly E_SHA1="sha1"
readonly E_SHA224="sha224"
readonly E_SHA256="sha256"
readonly E_SHA384="sha384"
readonly E_SHA512="sha512"
readonly E_SPACE="space"
readonly E_TRUE="true"
readonly E_WHIRLPOOL="whirlpool"
readonly E_UPPER="upper"
readonly E_XDIGIT="xdigit"
readonly E_YES="yes"
readonly E_SUCCESS="success"

readonly COMPRESSION_ALGORITHM_OPTIONS=( "${E_LZMA2}" "${E_GZIP}" "${E_BZIP2}" "" )
readonly COMPRESSION_LEVEL_LZMA2_OPTIONS=( "${E_1}" "${E_2}" "${E_3}" "${E_4}" "${E_5}" "${E_6}" "${E_7}" "${E_8}" "${E_9}" "${E_1E}" "${E_2E}" "${E_3E}" "${E_4E}" "${E_5E}" "${E_6E}" "${E_7E}" "${E_8E}" "${E_9E}" )
readonly COMPRESSION_LEVEL_GZIP_OPTIONS=( "${E_1}" "${E_2}" "${E_3}" "${E_4}" "${E_5}" "${E_6}" "${E_7}" "${E_8}" "${E_9}" )
readonly COMPRESSION_LEVEL_BZIP2_OPTIONS=( "${E_1}" "${E_2}" "${E_3}" "${E_4}" "${E_5}" "${E_6}" "${E_7}" "${E_8}" "${E_9}" )
readonly COMPRESSION_PRESERVE_PERMISSIONS_OPTIONS=( "${E_YES}" "${E_NO}" )
readonly SECURITY_CHECKSUM_ALGORITHM_OPTIONS=( "${E_MD4}" "${E_MD5}" "${E_MDC2}" "${E_RIPEMD160}" "${E_SHA}" "${E_SHA1}" "${E_SHA224}" "${E_SHA256}" "${E_SHA384}" "${E_SHA512}" "${E_WHIRLPOOL}" )
readonly SECURITY_ENCRYPTION_ENABLE_OPTIONS=( "${E_YES}" "${E_NO}" )
readonly SECURITY_ENCRYPTION_KEY_SIZE_OPTIONS=( "${E_128}" "${E_192}" "${E_256}" )
readonly SECURITY_ENCRYPTION_BASE64_ENCODE_OPTIONS=( "${E_YES}" "${E_NO}" )
readonly SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_PATTERN_OPTIONS=( "${E_ALNUM}" "${E_ALPHA}" "${E_BLANK}" "${E_CNTRL}" "${E_DIGIT}" "${E_GRAPH}" "${E_LOWER}" "${E_PRINT}" "${E_PUNCT}" "${E_SPACE}" "${E_UPPER}" "${E_XDIGIT}" )
readonly REPORTS_ATTACH_PASSPHRASES_OPTIONS=( "${E_YES}" "${E_NO}" )
readonly REMOTE_KEEP_BACKUP_LOCALLY_OPTIONS=( "${E_NEVER}" "${E_ERROR}" "${E_PARTIAL}" "${E_SUCCESS}" )
readonly FILESYSTEM_FOLLOW_SYMLINKS_OPTIONS=( "${E_YES}" "${E_NO}" )
readonly MISC_FOLLOW_SYMLINKS_OPTIONS=( "${E_YES}" "${E_NO}" )
readonly MISC_REMOVE_PATH_WHEN_DONE_OPTIONS=( "${E_YES}" "${E_NO}" )

readonly NUMBER_REGEX="^-?[0-9]+$"
readonly NATURAL_NUMBER_REGEX="^[1-9][0-9]*$"
readonly EMAIL_ADDRESS_REGEX="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

BASENAME="basename"
BZIP2="bzip2"
CALLER="caller"
CAT="cat"
CD="cd"
CHOWN="chown"
CUT="cut"
DATE="date"
DIRNAME="dirname"
DU="du"
ECHO="echo"
EXPR="expr"
FLOCK="flock"
GREP="grep"
GZIP="gzip"
HEAD="head"
HOSTNAME="hostname"
JQ="jq"
LOGGER="logger"
MAIL="mail"
MKDIR="mkdir"
MYSQL_DUMP="mysqldump"
OPENSSL="openssl"
PGSQL_DUMP="pg_dump"
PGSQL_DUMP_ALL="pg_dumpall"
PRINTF="printf"
READLINK="readlink"
RM="rm"
SCP="scp"
SLAPCAT="slapcat"
SSH="ssh"
STRINGS="strings"
SUDO="sudo"
TAR="tar"
TR="tr"
XZ="xz"


function findCommand()
{
    local cmd

    local ifs="${IFS}"
    IFS=':'
    for p in ${PATH} ;
    do
        cmd="${p}/${2}"
        eval "${cmd}" --test > /dev/null 2>&1
        if [[ $? != 127 && $? != 126 ]] ;
        then
            IFS="${ifs}"
            eval "${1}='${cmd}'"
            return 0
        fi
    done 
    IFS="${ifs}"

    eval "${1}='${2}'"
    return 1
}


function blindInitialize()
{
    local rc

    local ifs="${IFS}"
    IFS=' '
    local commands
    commands=( $( < "${CONFIG_FILE}" jq --raw-output '.command | keys | join(" ")' ) )
    rc=$?
    IFS="${ifs}"

    if [[ ${rc} -eq 0 ]] ;
    then
        for cmd in "${commands[@]}" ;
        do
            local cmd_var="${cmd^^}"

            case "${cmd}" in
            "caller" | "cd")
                eval "${cmd_var}='${cmd}'"
                continue
                ;;
            esac

            findCommand ${cmd_var} "${cmd}"
        done
    fi
}


function initializeCommands()
{
    for cmd in "$@" ;
    do
        local cmd_var="${cmd^^}"
        findCommand ${cmd_var} "${cmd}"

        if [[ $? -eq 0 ]] ;
        then
            if [[ -n "${ECHO}" && -n "${CUT}" && -n "${LOGGER}" ]] ;
            then
                eval logInfo "Found command \'\${${cmd_var}}\'."
            fi
        else
            logFatal "'${cmd}' command not found!"
        fi
    done
}


function log()
{
    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    if [[ -n "$@" ]] ;
    then
        echo "[$( "${DATE}" )] ${line} <== $@" >> "${LOG_FILE}"
        ${LOGGER} -s "[${SYSLOG_TAG}] ${line} <== $@"
    fi
}


function logDebug()
{
    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    log "${DEBUG_TAG} ${line} <== $@"
}


function logError()
{
    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    REPORTS_STATUS="${ERROR_TAG}"
    log "${ERROR_TAG} ${line} <== $@"
}


function logFatal()
{
    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    REPORTS_STATUS="${FATAL_TAG}"
    log "${FATAL_TAG} ${line} <== $@"

    cleanUp
    sendReports
    exit 1
}


function logInfo()
{
    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    log "${INFO_TAG} ${line} <== $@"
}


function logSuccess()
{
    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    log "${SUCCESS_TAG} ${line} <== $@"
}


function logTrace()
{
    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    log "${TRACE_TAG} ${line} <== $@"
}


function logWarning()
{
    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    log "${WARNING_TAG} ${line} <== $@"
}


function logCommandReturnCode()
{
    local cmd_name="${1}"
    local cmd_rc="${2}"
    local parent_line="${3}"

    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
    if [[ -n "${parent_line}" ]] ;
    then
        line="${line} <== ${parent_line}"
    fi

    local cmd="${cmd_name^^}"
    local rc_hash="CONF_COMMAND_${cmd}_RETURN_CODES"

    local message
    eval "message=\${${rc_hash}['rc_${cmd_rc}']}"

    if [[ -z ${message} ]] ;
    then
        eval "message=\${${rc_hash}['rc_any']}"
    fi

    eval "log \"${line} <== \${${cmd}}: ${message}\""
}


function acquireLock()
{
    local temp_file="/var/tmp/${BACKUP_TAG}.tmp"
    exec {FD}>"${temp_file}"
    exec {FD}>&-
    removeFileOrDirectory "${temp_file}"

    eval "exec ${FD}>${LOCK_FILE}"

    local flag
    ${FLOCK} -n ${FD} && flag=0 || flag=1
    local rc=$?

    if [[ ${rc} -eq 0 ]] ;
    then
        if [[ ${flag} -eq 0 ]] ;
        then
            readonly LOCK_IS_ACQUIRED="${E_YES}"
            trap "releaseLock" EXIT
        fi
    else
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
        if [[ -n "${parent_line}" ]] ;
        then
            line="${line} <== ${parent_line}"
        fi

        logCommandReturnCode "flock" ${rc} "${line}"
        REPORTS_STATUS="${ERROR_TAG}"
    fi

    return ${flag}
}


function releaseLock()
{
    if [[ "${LOCK_IS_ACQUIRED}" != "${E_YES}" ]] ;
    then
        return
    fi

    log "Releasing the lock file '${LOCK_FILE}'..."
    ${FLOCK} -u ${FD}
    local rc=$?

    if [[ ${rc} -eq 0 ]] ;
    then
        logInfo "Successfully released the lock."
        removeFileOrDirectory ${LOCK_FILE}
        rc=$?

        if [[ ${rc} -eq 0 ]] ;
        then
            logInfo "Successfully removed the lock file."
        else
            logError "Failed to clean-up the lock file!"
        fi
    else
        logCommandReturnCode "flock" ${rc} "${line}"
        logError "Failed to drop the lock!"
    fi
}


function configParseError()
{
    local error="${1}"
    local parent_line="${2}"

    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
    if [[ -n "${parent_line}" ]] ;
    then
        line="${line} <== ${parent_line}"
    fi

    if [[ -n "${error}" ]] ;
    then
        logError "${line} <== ${error}"
    fi

    logFatal "${line} <== JSON parse error in '${CONFIG_FILE}'!"
}


function jsonHas()
{
    local key="${2}"
    local object="${3}"
    local parent_line="${4}"

    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
    if [[ -n "${parent_line}" ]] ;
    then
        line="${line} <== ${parent_line}"
    fi

    if [[ ! -f "${CONFIG_FILE}" ]] ;
    then
        logFatal "${line} <== '${CONFIG_FILE}' does not exists!"
    fi

    local rcs
    local json_has_raw_output

    if [[ -z "${object}" ]] ;
    then
        json_has_raw_output=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "has(\"${key}\")" )
    else
        local null_object=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "${object}" )
        if [[ "${null_object}" == "null" ||
                -z "${null_object}" ]] ;
        then
            eval "${1}='${E_FALSE}'"
            return
        fi

        json_has_raw_output=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "${object} | has(\"${key}\")" )
    fi

    rcs=( ${PIPESTATUS[*]} )

    if [[ ${rcs[0]} -ne 0 || ${rcs[1]} -ne 0 ]] ;
    then
        if [[ ${rcs[0]} -ne 0 ]] ;
        then
            logCommandReturnCode "cat" ${rcs[0]} "${line}"
        fi

        if [[ ${rcs[1]} -ne 0 ]] ;
        then
            logCommandReturnCode "jq" ${rcs[1]} "${line}"
        fi

        configParseError "" "${line}"
    fi

    eval "${1}='${json_has_raw_output}'"
}


function jsonSelect()
{
    local object="${2}"
    local boolean_expression="${3}"
    local parent_line="${4}"

    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
    if [[ -n "${parent_line}" ]] ;
    then
        line="${line} <== ${parent_line}"
    fi

    if [[ ! -f "${CONFIG_FILE}" ]] ;
    then
        logFatal "${line} <== '${CONFIG_FILE}' does not exists!"
    fi

    local rcs
    local json_select_raw_output

    if [[ -z "${object}" ]] ;
    then
        json_select_raw_output=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "select(${boolean_expression})" )
    else
        local null_object=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "${object}" )
        if [[ "${null_object}" == "null"
                || -z "${null_object}" ]] ;
        then
            eval "${1}=''"
            return
        fi

        json_select_raw_output=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "${object} | select(${boolean_expression})" )
    fi

    rcs=( ${PIPESTATUS[*]} )

    if [[ ${rcs[0]} -ne 0 || ${rcs[1]} -ne 0 ]] ;
    then
        if [[ ${rcs[0]} -ne 0 ]] ;
        then
            logCommandReturnCode "cat" ${rcs[0]} "${line}"
        fi

        if [[ ${rcs[1]} -ne 0 ]] ;
        then
            logCommandReturnCode "jq" ${rcs[1]} "${line}"
        fi

        configParseError "" "${line}"
    fi

    eval "${1}='${json_select_raw_output}'"
}


function jsonLength()
{
    local object="${2}"
    local parent_line="${3}"

    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
    if [[ -n "${parent_line}" ]] ;
    then
        line="${line} <== ${parent_line}"
    fi

    if [[ ! -f "${CONFIG_FILE}" ]] ;
    then
        logFatal "${line} <== '${CONFIG_FILE}' does not exists!"
    fi

    local rcs
    local json_length_raw_output

    if [[ -z "${object}" ]] ;
    then
        json_length_raw_output=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "length" )
    else
        local null_object=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "${object}" )
        if [[ "${null_object}" == "null" ||
                -z "${null_object}" ]] ;
        then
            eval "${1}=0"
            return
        fi

        json_length_raw_output=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "${object} | length" )
    fi

    rcs=( ${PIPESTATUS[*]} )

    if [[ ${rcs[0]} -ne 0 || ${rcs[1]} -ne 0 ]] ;
    then
        if [[ ${rcs[0]} -ne 0 ]] ;
        then
            logCommandReturnCode "cat" ${rcs[0]} "${line}"
        fi

        if [[ ${rcs[1]} -ne 0 ]] ;
        then
            logCommandReturnCode "jq" ${rcs[1]} "${line}"
        fi

        configParseError "" "${line}"
    fi

    eval "${1}='${json_length_raw_output}'"
}


function jsonValue()
{
    local key="${2}"
    local treat_null_as_error="${3}"
    local parent_line="${4}"

    if [[ -z "${treat_null_as_error}" ]] ;
    then
        treat_null_as_error="${E_YES}"
    fi

    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
    if [[ -n "${parent_line}" ]] ;
    then
        line="${line} <== ${parent_line}"
    fi

    if [[ ! -f "${CONFIG_FILE}" ]] ;
    then
        logFatal "${line} <== '${CONFIG_FILE}' does not exists!"
    fi

    local rcs
    local json_value_raw_output

    json_value_raw_output=$( "${CAT}" "${CONFIG_FILE}" | ${JQ} --raw-output "${key}" )
    rcs=( ${PIPESTATUS[*]} )

    if [[ ${rcs[0]} -eq 0 || ${rcs[1]} -eq 0 ]] ;
    then
        if [[ "${treat_null_as_error}" == "${E_YES}" && "${json_value_raw_output}" == "${E_NULL}" ]] ;
        then
            configParseError "'${key}' is null!" "${line}"
        fi
    else
        if [[ ${rcs[0]} -ne 0 ]] ;
        then
            logCommandReturnCode "cat" ${rcs[0]} "${line}"
        fi

        if [[ ${rcs[1]} -ne 0 ]] ;
        then
            logCommandReturnCode "jq" ${rcs[1]} "${line}"
        fi

        configParseError "" "${line}"
    fi

    eval "${1}='${json_value_raw_output}'"
}


function verifyConfigOption()
{
    local option="${1}"
    local options=("${!2}")

    local rc=1
    for item in "${options[@]}" ;
    do
        if [[ "${option}" == "${item}" ]] ;
        then
            rc=0
            break
        fi
    done

    if [[ ${rc} -ne 0 ]] ;
    then
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
        configParseError "Invalid option '${option}'!" "${line}"
    fi

    return ${rc}
}


function changeOwnership()
{
    local path="${1}"
    local recursive="${2}"
    local user="${3}"
    local group="${4}"

    local flags
    if [[ ${recursive} == "${E_YES}" ]] ;
    then
        flags="-R"
    fi

    if [[ ( -n "${user}" && -n "${group}" ) ]] ;
    then
        "${CHOWN}" ${flags} ${user}:${group} "${path}"
        rc=$?
    elif [[ ( -n "${user}" ) ]] ;
    then
        "${CHOWN}" ${flags} ${user} "${path}"
        rc=$?
    elif [[ ( -n "${group}" ) ]] ;
    then
        "${CHOWN}" ${flags} :${group} "${path}"
        rc=$?
    fi

    if [[ ${rc} -ne 0 ]] ;
    then
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
        logCommandReturnCode "chown" ${rc} "${line}"
        logError "${line} <== Cannot change the ownership of '${path}'!"
        return 1
    fi

    return 0
}


function makeDirectory()
{
    local directory="${1}"
    local user="${2}"
    local group="${3}"

    local rc

    if [[ ( -n "${user}" && -n "${group}" ) ]] ;
    then
        "${SUDO}" -u ${user} -g ${group} -H ${MKDIR} -p "${directory}"
        rc=$?
    elif [[ ( -n "${user}" ) ]] ;
    then
        "${SUDO}" -u ${user} -g ${group} -H ${MKDIR} -p "${directory}"
    else
        ${MKDIR} -p "${directory}"
        rc=$?
    fi

    if [[ ${rc} -ne 0 ]] ;
    then
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
        logCommandReturnCode "mkdir" ${rc} "${line}"
        logError "${line} <== Cannot create '${directory}' directory!"
        return 1
    fi

    return 0
}


function changeDirectory()
{
    local directory="${1}"

    ${CD} "${directory}"
    local rc=$?

    if [[ ${rc} -ne 0 ]] ;
    then
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
        logCommandReturnCode "cd" ${rc} "${line}"
        logError "${line} <== Cannot change current path to '${directory}' directory!"
        return 1
    fi

    return 0
}


function removeFileOrDirectory()
{
    local path="${1}"

    ${RM} -rf ${path}
    local rc=$?

    if [[ ${rc} -ne 0 ]] ;
    then
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
        logCommandReturnCode "cd" ${rc} "${line}"
        logError "${line} <== Cannot remove '${path}'!"
        return 1;
    fi

    return 0
}


function getFileSize()
{
    local file_path="${2}"

    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    if [[ ! -f "${file_path}" ]] ;
    then
        logError "${line} <== '${file_path}' does not exists!"
        eval "${1}='0'"
        return 1;
    fi

    local size
    size="~ $( ${DU} -h "$file_path" | ${CUT} -f1 )"
    rcs=( ${PIPESTATUS[*]} )

    if [[ ${rcs[0]} -ne 0 || ${rcs[1]} -ne 0 ]] ;
    then
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

        if [[ ${rcs[0]} -ne 0 ]] ;
        then
            logCommandReturnCode "du" ${rcs[0]} "${line}"
            REPORTS_STATUS="${ERROR_TAG}"
        fi

        if [[ ${rcs[1]} -ne 0 ]] ;
        then
            logCommandReturnCode "cut" ${rcs[1]} "${line}"
            REPORTS_STATUS="${ERROR_TAG}"
        fi

        eval "${1}='0'"
        return 1
    fi

    eval "${1}='${size}'"

    return 0
}


function verifyPrivateKeyFormat()
{
    local private_key="${1}"

    "${OPENSSL}" rsa -in "${private_key}" -check -noout > /dev/null 2>&1
    if [[ $? -ne 0 ]] ;
    then
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
        logCommandReturnCode "openssl" ${rc} "${line}"
        REPORTS_STATUS="${ERROR_TAG}"
        return 1
    fi

    return 0
}


function verifyPublicKeyFormat()
{
    local public_key="${1}"

    "${OPENSSL}" rsa -inform PEM -pubin -in "${public_key}" -noout > /dev/null 2>&1
    if [[ $? -ne 0 ]] ;
    then
        local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )
        logCommandReturnCode "openssl" ${rc} "${line}"
        REPORTS_STATUS="${ERROR_TAG}"
        return 1
    fi

    return 0
}


function dumpDatabase()
{
    local type="${1}"
    local name="${2}"
    local dump_file="${3}"

    local cmd
    local rc

    local line=$( "${ECHO}" $( "${CALLER}" 0 ) | "${CUT}" -d " " -f1 )

    if [[ "${name}" == "'${E_ASTERISK}'" ]] ;
    then
        name="${name%\'}"
        name="${name#\'}"
    fi

    case "${type}" in
    "${E_POSTGRES}")
        if [[ "${name}" != "${E_ASTERISK}" ]] ;
        then
            if [[ ( -n "${CONF_BACKUP_DATABASE_POSTGRES_USER}" && -n "${CONF_BACKUP_DATABASE_POSTGRES_GROUP}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_DATABASE_POSTGRES_USER} -g ${CONF_BACKUP_DATABASE_POSTGRES_GROUP} -H ${PGSQL_DUMP} ${name} > ${dump_file}
                rc=$?
            elif [[ ( -n "${CONF_BACKUP_DATABASE_POSTGRES_USER}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_DATABASE_POSTGRES_USER} -H ${PGSQL_DUMP} ${name} > ${dump_file}
                rc=$?
            fi
            cmd="pg_dump"
        else
            if [[ ( -n "${CONF_BACKUP_DATABASE_POSTGRES_USER}" && -n "${CONF_BACKUP_DATABASE_POSTGRES_GROUP}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_DATABASE_POSTGRES_USER} -g ${CONF_BACKUP_DATABASE_POSTGRES_GROUP} -H ${PGSQL_DUMP_ALL} > ${dump_file}
                rc=$?
            elif [[ ( -n "${CONF_BACKUP_DATABASE_POSTGRES_USER}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_DATABASE_POSTGRES_USER} -H ${PGSQL_DUMP_ALL} > ${dump_file}
                rc=$?
            fi
            cmd="pg_dumpall"
        fi
        ;;
    "${E_MYSQL}")
        if [[ "${name}" != "${E_ASTERISK}" ]] ;
        then
            if [[ ( -n "${CONF_BACKUP_DATABASE_MYSQL_USER}" && -n "${CONF_BACKUP_OPENDATABASE_MYSQLLDAP_GROUP}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_DATABASE_MYSQL_USER} -g ${CONF_BACKUP_DATABASE_MYSQL_GROUP} -H ${MYSQL_DUMP} --single-transaction -u ${CONF_BACKUP_DATABASE_MYSQL_INTERNAL_USER} ${name} > ${dump_file}
                rc=$?
            elif [[ ( -n "${CONF_BACKUP_DATABASE_MYSQL_USER}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_DATABASE_MYSQL_USER} -H ${MYSQL_DUMP} --single-transaction -u ${CONF_BACKUP_DATABASE_MYSQL_INTERNAL_USER} ${name} > ${dump_file}
                rc=$?
            else
                ${MYSQL_DUMP} --single-transaction -u ${CONF_BACKUP_DATABASE_MYSQL_INTERNAL_USER} ${name} > ${dump_file}
                rc=$?
            fi
            cmd="mysqldump"
        else
            if [[ ( -n "${CONF_BACKUP_DATABASE_MYSQL_USER}" && -n "${CONF_BACKUP_DATABASE_MYSQL_GROUP}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_DATABASE_MYSQL_USER} -g ${CONF_BACKUP_DATABASE_MYSQL_GROUP} -H ${MYSQL_DUMP} --single-transaction -u ${CONF_BACKUP_DATABASE_MYSQL_INTERNAL_USER} --events --all-databases > ${dump_file}
                rc=$?
            elif [[ ( -n "${CONF_BACKUP_DATABASE_MYSQL_USER}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_DATABASE_MYSQL_USER} -H ${MYSQL_DUMP} --single-transaction -u ${CONF_BACKUP_DATABASE_MYSQL_INTERNAL_USER} --events --all-databases > ${dump_file}
                rc=$?
            else
                ${MYSQL_DUMP} --single-transaction -u ${CONF_BACKUP_DATABASE_MYSQL_INTERNAL_USER} --events --all-databases > ${dump_file}
                rc=$?
            fi
            cmd="mysqldump"
        fi
        ;;
    *)
        logError "${line} <== Unknown database type '${type}' for '${name}'!"
        return 1
        ;;
    esac

    if [[ ${rc} -ne 0 ]] ;
    then
        logCommandReturnCode "${cmd}" ${rc} "${line}"
        logError "${line} <== Dump failed for '${type}::${name}'!"
        return 1
    fi

    return 0
}


function createArchive()
{
    local working_dir="${1}"
    local path="${2}"
    local archive_file="${3}"
    local follow_symlinks="${4}"

    changeDirectory "${working_dir}"
    if [[ $? -ne 0 ]] ;
    then
        return 1
    fi

    local rc
    local rcs

    case "${follow_symlinks}" in
    "${E_YES}")
        if [[ "${CONF_COMPRESSION_ALGORITHM}" != "" ]] ;
        then
            ${TAR} ${TAR_OPTION_FOLLOW_SYMLINKS} ${TAR_OPTIONS} ${path} | ${ARCHIVE_COMPRESSOR} ${ARCHIVE_COMPRESSOR_OPTIONS} > ${archive_file}
            rcs=( ${PIPESTATUS[*]} )
        else
            ${TAR} ${TAR_OPTION_FOLLOW_SYMLINKS} ${TAR_OPTIONS} ${archive_file} ${path}
            rc=$?
        fi
        ;;
    "${E_NO}")
        if [[ "${CONF_COMPRESSION_ALGORITHM}" != "" ]] ;
        then
            ${TAR} ${TAR_OPTIONS} ${path} | ${ARCHIVE_COMPRESSOR} ${ARCHIVE_COMPRESSOR_OPTIONS} > ${archive_file}
            rcs=( ${PIPESTATUS[*]} )
        else
            ${TAR} ${TAR_OPTIONS} ${archive_file} ${path}
            rc=$?
        fi
        ;;
    *)
        logError "Invalid option '${follow_symlinks}'!"
        return 1
    esac

    if [[ -n "${rc}" ]] ;
    then
        logCommandReturnCode "tar" ${rc}
        REPORTS_STATUS="${ERROR_TAG}"
        return 1
    else
        if [[ ${rcs[0]} -ne 0 || ${rcs[1]} -ne 0 ]] ;
        then
            if [[ ${rcs[0]} -ne 0 ]] ;
            then
                logCommandReturnCode "tar" ${rcs[0]}
            fi

            if [[ ${rcs[1]} -ne 0 ]] ;
            then
                logCommandReturnCode "${ARCHIVE_COMPRESSOR_NAME}" ${rcs[1]}
            fi

            REPORTS_STATUS="${ERROR_TAG}"
            return 1
        fi
    fi

    return 0
}


function generateArchiveSecret()
{
    local working_dir="${1}"
    local secret_file="${2}"
    local pattern="${3}"
    local length="${4}"

    changeDirectory "${working_dir}"
    if [[ $? -ne 0 ]] ;
    then
        return 1
    fi

    local rcs
    ${STRINGS} /dev/urandom | ${GREP} -o "[[:${pattern}:]]" | ${HEAD} -n ${length} | ${TR} -d '\n' > "${secret_file}"
    rcs=( ${PIPESTATUS[*]} )

    if [[ ( ${rcs[0]} -ne 0 && ${rcs[0]} -ne 141 )
            || ( ${rcs[1]} -ne 0 && ${rcs[1]} -ne 141 ) 
            || ( ${rcs[2]} -ne 0 && ${rcs[2]} -ne 141 ) 
            || ( ${rcs[3]} -ne 0 && ${rcs[3]} -ne 141 ) ]] ;
    then
        if [[ ${rcs[0]} -ne 0 && ${rcs[0]} -ne 141 ]] ;
        then
            logCommandReturnCode "strings" ${rcs[0]}
        fi

        if [[ ${rcs[1]} -ne 0 && ${rcs[1]} -ne 141 ]] ;
        then
            logCommandReturnCode "grep" ${rcs[1]}
        fi

        if [[ ${rcs[2]} -ne 0 && ${rcs[2]} -ne 141 ]] ;
        then
            logCommandReturnCode "head" ${rcs[2]}
        fi

        if [[ ${rcs[3]} -ne 0 && ${rcs[3]} -ne 141 ]] ;
        then
            logCommandReturnCode "tr" ${rcs[3]}
        fi

        REPORTS_STATUS="${ERROR_TAG}"
        return 1
    fi

    return 0
}


function encryptArchive()
{
    local working_dir="${1}"
    local archive_file="${2}"
    local encrypted_file="${3}"
    local key_size="${4}"
    local secret_file="${5}"
    local base64_encode="${6}"

    changeDirectory "${working_dir}"
    if [[ $? -ne 0 ]] ;
    then
        return 1
    fi

    if [[ ! -f "${archive_file}" ]] ;
    then
        logError "'${archive_file}' does not exists!"
        return 1;
    fi

    if [[ ! -f "${secret_file}" ]] ;
    then
        logError "'${secret_file}' does not exists!"
        return 1;
    fi

    local rc

    if [[ "${base64_encode}" == "${E_YES}" ]] ;
    then
        "${OPENSSL}" enc -aes-${key_size}-cbc -salt -a -in "${archive_file}" -out "${encrypted_file}" -pass file:"${secret_file}" -md sha1
        rc=$?
    elif [[ "${base64_encode}" == "${E_NO}" ]] ;
    then
        "${OPENSSL}" enc -aes-${key_size}-cbc -salt -in "${archive_file}" -out "${encrypted_file}" -pass file:"${secret_file}" -md sha1
        rc=$?
    else
        logError "Invalid option '${base64_encode}'!"
        return 1
    fi

    if [[ ${rc} -ne 0 ]] ;
    then
        logCommandReturnCode "openssl" ${rc}
        REPORTS_STATUS="${ERROR_TAG}"
        return 1
    fi

    return 0
}


function encryptArchiveSecret()
{
    local working_dir="${1}"
    local secret_file="${2}"
    local encrypted_file="${3}"
    local public_key="${4}"
    local base64_encode="${5}"

    changeDirectory "${working_dir}"
    if [[ $? -ne 0 ]] ;
    then
        return 1
    fi

    if [[ ! -f "${secret_file}" ]] ;
    then
        logError "'${secret_file}' does not exists!"
        return 1
    fi

    if [[ ! -f "${public_key}" ]] ;
    then
        logError "'${public_key}' does not exists!"
        return 1
    fi

    verifyPublicKeyFormat "${public_key}"
    if [[ $? -ne 0 ]] ;
    then
        logError "'${public_key}' is not a valid RSA public key!"
        return 1
    fi

    if [[ "${base64_encode}" == "${E_YES}" ]] ;
    then
        local rcs
        "${OPENSSL}" rsautl -encrypt -inkey "${public_key}" -pubin -in "${secret_file}" | openssl base64 -out "${encrypted_file}"
        rcs=( ${PIPESTATUS[*]} )

        if [[ ${rcs[0]} -ne 0 || ${rcs[1]} -ne 0 ]] ;
        then
            if [[ ${rcs[0]} -ne 0 ]] ;
            then
                logCommandReturnCode "openssl" ${rcs[0]}
            fi

            if [[ ${rcs[1]} -ne 0 ]] ;
            then
                logCommandReturnCode "openssl" ${rcs[1]}
            fi

            REPORTS_STATUS="${ERROR_TAG}"
            return 1
        fi
    elif [[ "${base64_encode}" == "${E_NO}" ]] ;
    then
        "${OPENSSL}" rsautl -encrypt -inkey "${public_key}" -pubin -in "${secret_file}" -out "${encrypted_file}"
        if [[ $? -ne 0 ]] ;
        then
            logCommandReturnCode "openssl" ${rc}
            REPORTS_STATUS="${ERROR_TAG}"
            return 1
        fi
    else
        logError "Invalid option '${base64_encode}'!"
        return 1
    fi

    return 0
}

function generateArchiveChecksum()
{
    local working_dir="${1}"
    local archive_file="${2}"
    local checksum_file="${3}"
    local algorithm="${4}"

    changeDirectory "${working_dir}"
    if [[ $? -ne 0 ]] ;
    then
        return 1
    fi

    if [[ ! -f "${archive_file}" ]] ;
    then
        logError "'${archive_file}' does not exists!"
        return 1;
    fi

    "${OPENSSL}" dgst -${algorithm} -out "${checksum_file}" "${archive_file}"
    if [[ $? -ne 0 ]] ;
    then
        logCommandReturnCode "openssl" ${rc}
        REPORTS_STATUS="${ERROR_TAG}"
        return 1
    fi

    return 0
}


function signArchive()
{
    local working_dir="${1}"
    local checksum_file="${2}"
    local signature_file="${3}"
    local private_key="${4}"
    local base64_encode="${5}"

    changeDirectory "${working_dir}"
    if [[ $? -ne 0 ]] ;
    then
        return 1
    fi

    if [[ ! -f "${checksum_file}" ]] ;
    then
        logError "'${checksum_file}' does not exists!"
        return 1;
    fi

    if [[ ! -f "${private_key}" ]] ;
    then
        logError "'${private_key}' does not exists!"
        return 1;
    fi

    if [[ "${base64_encode}" == "${E_YES}" ]] ;
    then
        local rcs
        "${OPENSSL}" rsautl -sign -inkey "${private_key}" -keyform PEM -in ${checksum_file} | openssl base64 -out "${signature_file}"
        rcs=( ${PIPESTATUS[*]} )

        if [[ ${rcs[0]} -ne 0 || ${rcs[1]} -ne 0 ]] ;
        then
            if [[ ${rcs[0]} -ne 0 ]] ;
            then
                logCommandReturnCode "openssl" ${rcs[0]}
            fi

            if [[ ${rcs[1]} -ne 0 ]] ;
            then
                logCommandReturnCode "openssl" ${rcs[1]}
            fi

            REPORTS_STATUS="${ERROR_TAG}"
            return 1
        fi
    elif [[ "${base64_encode}" == "${E_NO}" ]] ;
    then
        "${OPENSSL}" rsautl -sign -inkey "${private_key}" -keyform PEM -in ${checksum_file} -out "${signature_file}"
        if [[ $? -ne 0 ]] ;
        then
            logCommandReturnCode "openssl" ${rc}
            REPORTS_STATUS="${ERROR_TAG}"
            return 1
        fi
    else
        logError "Invalid option '${base64_encode}'!"
        return 1
    fi

    return 0
}


function uploadArchive()
{
    local working_dir="${1}"
    local comment="${2}"
    local tag="${3}"
    local archive_file="${4}"
    local checksum_file="${5}"
    local encrypted_archive_file="${6}"
    local signature_file="${7}"
    local secret_file="${8}"
    local encrypted_secret_file="${9}"
    local base64_encode="${10}"

    if [[ ${CONF_REMOTE_SERVERS} -le 0 ]] ;
    then
        return
    fi

    changeDirectory "${working_dir}"
    if [[ $? -ne 0 ]] ;
    then
        return 1
    fi

    local rc
    local remote_server_array_name
    local remote_host
    local remote_port
    local remote_user
    local remote_dir
    local public_key
    local file_size
    local index

    local any_success=${E_NO}
    local some_fail=${E_NO}

    for (( index = 0; index < ${CONF_REMOTE_SERVERS}; ++index ))
    do
        eval "remote_server_array_name=CONF_REMOTE_SERVER_${index}"
        eval "remote_host=\${${remote_server_array_name}['host']}"
        eval "remote_port=\${${remote_server_array_name}['port']}"
        eval "remote_user=\${${remote_server_array_name}['user']}"
        eval "remote_dir=\${${remote_server_array_name}['dir']}"
        eval "public_key=\${${remote_server_array_name}['public_key']}"

        if [[ -n "${public_key}" ]] ;
        then
            if [[ ! -f "${public_key}" ]] ;
            then
                logError "'${public_key}' does not exists!"
                some_fail=${E_YES}
                continue
            fi

            verifyPublicKeyFormat "${public_key}"
            if [[ $? -ne 0 ]] ;
            then
                logFatal "'${public_key}' is not a valid RSA public key!"
                some_fail=${E_YES}
                continue
            fi
        fi

        remote_dir="${remote_dir}/${tag}/${BACKUP_DATE}"

        log "Checking if '${remote_user}@${remote_host}:${remote_port}/${remote_dir}' exists..."

        ${SSH} -p ${remote_port} ${remote_user}@${remote_host} "cd ${remote_dir} > /dev/null 2>&1"
        rc=$?

        if [[ ${rc} -eq 1 ]] ;
        then
            log "Creating '${remote_user}@${remote_host}:${remote_port}/${remote_dir}'"

            ${SSH} -p ${remote_port} ${remote_user}@${remote_host} "mkdir -p ${remote_dir} && cd ${remote_dir} > /dev/null 2>&1"
            rc=$?

            if [[ ${rc} -ne 0 ]] ;
            then
                logCommandReturnCode "ssh" ${rc}
                logError "Cannot connect to host '${remote_host}'!"
                some_fail=${E_YES}
                continue
            fi
        elif [[ ${rc} -ne 0 ]] ;
        then
            logCommandReturnCode "ssh" ${rc}
            logError "Cannot connect to host '${remote_host}'!"
            some_fail=${E_YES}
            continue
        fi

        log "Uploading to '${remote_user}@${remote_host}:${remote_port}/${remote_dir}'..."

        if [[ -n "${encrypted_archive_file}" ]] ;
        then
            getFileSize file_size "${encrypted_archive_file}"
            log "Uploading '${encrypted_archive_file}'... ${file_size}"

            ${SCP} -P ${remote_port} "${encrypted_archive_file}" ${remote_user}@${remote_host}:"${remote_dir}"
            rc=$?

            if [[ ${rc} -ne 0 ]] ;
            then
                logCommandReturnCode "scp" ${rc}
                logError "'${encrypted_archive_file} upload failed!"
                some_fail=${E_YES}
                continue
            fi

            if [[ -n ${signature_file} ]] ;
            then
                getFileSize file_size "${signature_file}"
                log "Uploading '${signature_file}'... ${file_size}"

                ${SCP} -P ${remote_port} "${signature_file}" ${remote_user}@${remote_host}:"${remote_dir}"
                rc=$?

                if [[ ${rc} -ne 0 ]] ;
                then
                    logCommandReturnCode "scp" ${rc}
                    logError "'${signature_file}' upload failed!"
                    some_fail=${E_YES}
                fi
            fi

            if [[ -n "${public_key}" ]] ;
            then
                if [[ -n "${secret_file}" && -n "${encrypted_secret_file}" ]] ;
                then
                    log "Encrypting archive passphrase using '${public_key}'..."
                    encryptArchiveSecret "${working_dir}" "${secret_file}" "${encrypted_secret_file}" "${public_key}" "${base64_encode}"
                    rc=$?

                    if [[ ${rc} -eq 0 ]] ;
                    then
                        getFileSize file_size "${encrypted_secret_file}"
                        log "Uploading '${encrypted_secret_file}'... ${file_size}"

                        ${SCP} -P ${remote_port} "${encrypted_secret_file}" ${remote_user}@${remote_host}:"${remote_dir}"
                        rc=$?

                        if [[ ${rc} -ne 0 ]] ;
                        then
                            logCommandReturnCode "scp" ${rc}
                            logError "'${encrypted_secret_file}' upload failed!"
                            some_fail=${E_YES}
                        fi
                    else
                        logError "Failed to encrypt archive passphrase using '${public_key}'!"
                        logError "Cannot upload '${encrypted_secret_file}'!"
                        logWarning "You may not be able to restore '${encrypted_archive_file}' later on unless you've got the passphrase!"
                        some_fail=${E_YES}
                    fi

                    if [[ -f "${encrypted_secret_file}" ]] ;
                    then
                        log "Removing '${encrypted_secret_file}'..."
                        removeFileOrDirectory "${encrypted_secret_file}"
                    fi
                else
                    logError "Don't know how to encrypt the archive secret!"
                fi
            else
                if [[ -n ${checksum_file} ]] ;
                then
                    getFileSize file_size "${checksum_file}"
                    log "Uploading '${checksum_file}'... ${file_size}"

                    ${SCP} -P ${remote_port} "${checksum_file}" ${remote_user}@${remote_host}:"${remote_dir}"
                    rc=$?

                    if [[ ${rc} -ne 0 ]] ;
                    then
                        logCommandReturnCode "scp" ${rc}
                        logError "'${checksum_file}' upload failed!"
                        some_fail=${E_YES}
                    fi
                fi
            fi

            any_success=${E_YES}
        elif [[ -n "${archive_file}" ]] ;
        then
            getFileSize file_size "${archive_file}"
            log "Uploading '${archive_file}'... ${file_size}"

            ${SCP} -P ${remote_port} "${archive_file}" ${remote_user}@${remote_host}:"${remote_dir}"
            rc=$?

            if [[ ${rc} -ne 0 ]] ;
            then
                logCommandReturnCode "scp" ${rc}
                logError "'${archive_file}' upload failed!"
                some_fail=${E_YES}
                continue
            fi

            if [[ -n ${checksum_file} ]] ;
            then
                getFileSize file_size "${checksum_file}"
                log "Uploading '${checksum_file}'... ${file_size}"

                ${SCP} -P ${remote_port} "${checksum_file}" ${remote_user}@${remote_host}:"${remote_dir}"
                rc=$?

                if [[ ${rc} -ne 0 ]] ;
                then
                    logCommandReturnCode "scp" ${rc}
                    logError "'${checksum_file}' upload failed!"
                    some_fail=${E_YES}
                fi
            fi

            any_success=${E_YES}
        else
            logError "No uploads for '${comment}'!"
            return 2
        fi
    done

    if [[ ${any_success} == ${E_YES} && ${some_fail} == ${E_NO} ]] ;
    then
        return 0
    elif [[ ${any_success} == ${E_YES} && ${some_fail} == ${E_YES} ]] ;
    then
        return 1
    else
        return 2
    fi
}


function archive()
{
    local comment="${1}"
    local tag="${2}"
    local path="${3}"
    local follow_symlinks="${4}"
    local remove_path_when_done="${5}"
    local remove_path_when_done_confirm_1="${6}"
    local remove_path_when_done_confirm_2="${7}"
    local remove_path_when_done_confirm_3="${8}"

    changeDirectory "${CONF_TEMP_DIR}"
    if [[ $? -ne 0 ]] ;
    then
        return 1
    fi

    if [[ -f "${path}" || -d "${path}" ]] ;
    then
        local rc

        local archive_file="${CONF_BACKUP_ARCHIVE_NAME//'{DATE}'/${BACKUP_DATE}}"
        archive_file="${archive_file//'{TIME}'/${BACKUP_TIME}}"
        archive_file="${archive_file//'{HOST_NAME}'/${BACKUP_HOST_NAME}}"
        archive_file="${archive_file//'{TAG}'/${tag}}"
        archive_file="${archive_file}.${ARCHIVE_EXTENSION}"
        archive_file="${CONF_TEMP_DIR}/${archive_file}"

        log "Creating archive '${archive_file}'..."
        createArchive "${CONF_TEMP_DIR}" "${path}" "${archive_file}" "${follow_symlinks}"
        rc=$?

        if [[ ${rc} -eq 0 ]] ;
        then
            if [[ "${remove_path_when_done}" == "${E_YES}"
                    && "${remove_path_when_done_confirm_1}" == "${E_YES}"
                    && "${remove_path_when_done_confirm_2}" == "${E_YES}"
                    && "${remove_path_when_done_confirm_3}" == "${E_YES}" ]] ;
            then
                log "Removing '${path}'..."
                removeFileOrDirectory ${path}
            elif [[ "${remove_path_when_done}" != "${E_NO}" ]] ;
            then
                logError "Invalid option!"
            fi

            local secret_file
            local encrypted_archive_file
            local checksum_file
            local signature_file
            local encrypted_secret_file

            if [[ "${CONF_SECURITY_ENCRYPTION_ENABLE}" == "${E_YES}" ]] ;
            then
                secret_file="${archive_file}.${SECRET_KEY_EXTENSION}"

                if [[ "${CONF_SECURITY_ENCRYPTION_PASSPHRASE}" == "" ]] ;
                then
                    log "Generating a random passphrase for '${archive_file}'..."
                    generateArchiveSecret "${CONF_TEMP_DIR}" "${secret_file}" "${CONF_SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_PATTERN}" "${CONF_SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_LENGTH}"
                    rc=$?

                    if [[ ${rc} -ne 0 ]] ;
                    then
                        logError "Secret key generation failed!"
                        logError "'${comment}' could not be uploaded!"
                        return 2
                    fi
                else
                    ${ECHO} "${CONF_SECURITY_ENCRYPTION_PASSPHRASE}" > "${secret_file}"
                    rc=$?

                    if [[ ${rc} -ne 0 ]] ;
                    then
                        logError "Secret key file creation failed!"
                        logError "'${comment}' could not be uploaded!"
                        return 2
                    fi
                fi

                encrypted_archive_file="${archive_file}.${ENCRYPTED_ARCHIVE_EXTENSION}"

                local passphrase
                passphrase=$( "${CAT}" "${secret_file}" )
                rc=$?

                if [[ ${rc} -eq 0 ]] ;
                then
                    local archive_name
                    archive_name="$( "${BASENAME}" "${encrypted_archive_file}" )"
                    rc=$?

                    if [[ ${rc} -ne 0 ]] ;
                    then
                        logCommandReturnCode "basename" ${rc}
                        REPORTS_STATUS="${ERROR_TAG}"
                    fi

                    if [[ -n "${REPORTS_PWD}" ]];
                    then
                        REPORTS_PWD=$( ${PRINTF} '%s\n[%s](%s)' "${REPORTS_PWD}" "${archive_name}" "${passphrase}" )
                    else
                        REPORTS_PWD="[${archive_name}](${passphrase})"
                    fi
                fi
                unset passphrase

                log "Encrypting '${archive_file}'..."
                encryptArchive "${CONF_TEMP_DIR}" "${archive_file}" "${encrypted_archive_file}" "${CONF_SECURITY_ENCRYPTION_KEY_SIZE}" "${secret_file}" "${CONF_SECURITY_ENCRYPTION_BASE64_ENCODE}"
                rc=$?

                if [[ ${rc} -ne 0 ]] ;
                then
                    logError "'${archive_file}' encryption failed!"
                    logError "'${comment}' could not be uploaded!"
                    return 2
                else
                    log "Removing '${archive_file}'..."
                    removeFileOrDirectory "${archive_file}"
                    archive_file=""
                fi

                checksum_file="${encrypted_archive_file}.${CHECKSUM_EXTENSION}"
            else
                checksum_file="${archive_file}.${CHECKSUM_EXTENSION}"
            fi

            log "Generating archive checksum '${checksum_file}'..."

            if [[ "${CONF_SECURITY_ENCRYPTION_ENABLE}" == "${E_YES}" ]] ;
            then
                generateArchiveChecksum "${CONF_TEMP_DIR}" "${encrypted_archive_file}" "${checksum_file}" "${CONF_SECURITY_CHECKSUM_ALGORITHM}"
                rc=$?
            else
                generateArchiveChecksum "${CONF_TEMP_DIR}" "${archive_file}" "${checksum_file}" "${CONF_SECURITY_CHECKSUM_ALGORITHM}"
                rc=$?
            fi

            if [[ ${rc} -eq 0 ]] ;
            then
                local checksum
                checksum=$( "${CAT}" "${checksum_file}" )
                rc=$?

                if [[ ${rc} -eq 0 ]] ;
                then
                    log "${checksum}"
                else
                    logError "Cannot read '${checksum_file}'!"
                fi
            else
                logError "'${checksum_file}' generation failed!"

                if [[ "${CONF_SECURITY_ENCRYPTION_ENABLE}" == "${E_YES}"
                        && "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}" != "" ]] ;
                then
                    logError "'${comment}' cannot be signed!"
                fi

                logWarning "You cannot verify '${comment}' integrity later on!"

                checksum_file=""
            fi

            if [[ "${CONF_SECURITY_ENCRYPTION_ENABLE}" == "${E_YES}"
                    && -n "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}"
                    && -n checksum_file ]] ;
            then
                if [[ -n "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}" ]] ;
                then
                    if [[ ! -f "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}" ]] ;
                    then
                        logError "'${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}' does not exists!"
                        logError "'${comment}' cannot be signed!"
                    else
                        verifyPrivateKeyFormat "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}"
                        rc=$?

                        if [[ ${rc} -ne 0 ]] ;
                        then
                            logError "'${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}' is not a valid RSA private key!"
                            logError "'${comment}' cannot be signed!"
                        else
                            signature_file="${encrypted_archive_file}.${SIGNATURE_EXTENSION}"

                            log "Signing '${encrypted_archive_file}'..."
                            signArchive "${CONF_TEMP_DIR}" "${checksum_file}" "${signature_file}" "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}" "${CONF_SECURITY_ENCRYPTION_BASE64_ENCODE}"
                            rc=$?

                            if [[ ${rc} -ne 0 ]] ;
                            then
                                logError "'${signature_file}' generation failed!!"
                                logError "Signing failed for '${comment}'!"

                                signature_file=""
                            else
                                log "Removing '${checksum_file}'..."
                                removeFileOrDirectory "${checksum_file}"
                                checksum_file=""
                            fi
                        fi
                    fi
                fi
            fi

            if [[ "${CONF_SECURITY_ENCRYPTION_ENABLE}" == "${E_YES}"
                    && -n "${encrypted_archive_file}" 
                    && -n "${secret_file}" ]] ;
            then
                encrypted_secret_file="${encrypted_archive_file}.${ENCRYPTED_SECRET_KEY_EXTENSION}"
            fi

            log "Uploading '${comment}'..."
            uploadArchive "${CONF_TEMP_DIR}" "${comment}" "${tag}" "${archive_file}" "${checksum_file}" "${encrypted_archive_file}" "${signature_file}" "${secret_file}" "${encrypted_secret_file}" "${CONF_SECURITY_ENCRYPTION_BASE64_ENCODE}"
            rc=$?

            local remove=${E_NO}
            if [[ ${CONF_REMOTE_KEEP_BACKUP_LOCALLY} == "${E_NEVER}" ]] ;
            then
                remove=${E_YES}
            else
                case ${rc} in
                0)
                    if [[ ${CONF_REMOTE_KEEP_BACKUP_LOCALLY} != "${E_SUCCESS}" ]] ;
                    then
                        remove=${E_YES}
                    fi
                    ;;
                1)
                    if [[ ${CONF_REMOTE_KEEP_BACKUP_LOCALLY} != "${E_SUCCESS}" 
                            && ${CONF_REMOTE_KEEP_BACKUP_LOCALLY} != "${E_PARTIAL}" ]] ;
                    then
                        remove=${E_YES}
                    fi
                    ;;
                *)
                    if [[ ${CONF_REMOTE_KEEP_BACKUP_LOCALLY} != "${E_SUCCESS}" 
                            && ${CONF_REMOTE_KEEP_BACKUP_LOCALLY} != "${E_PARTIAL}"
                            && ${CONF_REMOTE_KEEP_BACKUP_LOCALLY} != "${E_ERROR}" ]] ;
                    then
                        remove=${E_YES}
                    fi
                esac
            fi

            if [[ "${remove}" == "${E_YES}" ]] ;
            then
                if [[ -n "${archive_file}" && -f "${archive_file}" ]] ;
                then
                    log "Removing '${archive_file}'..."
                    removeFileOrDirectory "${archive_file}"
                fi

                if [[ -n "${checksum_file}" && -f "${checksum_file}" ]] ;
                then
                    log "Removing '${checksum_file}'..."
                    removeFileOrDirectory "${checksum_file}"
                fi

                if [[ -n "${encrypted_archive_file}" && -f "${encrypted_archive_file}" ]] ;
                then
                    log "Removing '${encrypted_archive_file}'..."
                    removeFileOrDirectory "${encrypted_archive_file}"
                fi

                if [[ -n "${signature_file}" && -f "${signature_file}" ]] ;
                then
                    log "Removing '${signature_file}'..."
                    removeFileOrDirectory "${signature_file}"
                fi

                if [[ -n "${secret_file}" && -f "${secret_file}" ]] ;
                then
                    log "Removing '${secret_file}'..."
                    removeFileOrDirectory "${secret_file}"
                fi

                if [[ -n "${encrypted_secret_file}" && -f "${encrypted_secret_file}" ]] ;
                then
                    log "Removing '${encrypted_secret_file}'..."
                    removeFileOrDirectory "${encrypted_secret_file}"
                fi
            else
                if [[ -n "${encrypted_archive_file}" && -f "${encrypted_archive_file}" ]] ;
                then
                    logInfo "Keeping '${encrypted_archive_file}' locally."
                elif [[ -n "${archive_file}" && -f "${archive_file}" ]] ;
                then
                    logInfo "Keeping '${archive_file}' locally."
                fi
            fi
        else
            logError "Archive creation for '${archive_file}' failed!"
            return 2
        fi
    else
        logError "'${path}' does not exists!"
        return 2
    fi

    return ${rc}
}


function backupLdap()
{
    if [[ -z ${CONF_BACKUP_OPENLDAP_TAG} ]] ;
    then
        return
    fi

    log "Creating a backup from OpenLDAP objects and directories..."

    local rc

    local backup_name="${CONF_BACKUP_ARCHIVE_NAME//'{DATE}'/${BACKUP_DATE}}"
    backup_name="${backup_name//'{TIME}'/${BACKUP_TIME}}"
    backup_name="${backup_name//'{HOST_NAME}'/${BACKUP_HOST_NAME}}"
    backup_name="${backup_name//'{TAG}'/${CONF_BACKUP_OPENLDAP_TAG}}"

    local dump_dir="${CONF_TEMP_DIR}/${backup_name}"
    local dump_file="${dump_dir}/${CONF_BACKUP_OPENLDAP_TAG}.ldif"

    log "Dumping to '${dump_file}'..."

    makeDirectory "${dump_dir}"
    rc=$?

    if [[ ${rc} -eq 0 ]] ;
    then
        changeOwnership "${dump_dir}" "${E_YES}" "${CONF_BACKUP_OPENLDAP_USER}" "${CONF_BACKUP_OPENLDAP_GROUP}"
        rc=$?

        if [[ ${rc} -eq 0 ]] ;
        then
            local slapcat_options

            if [[ -n "${CONF_BACKUP_OPENLDAP_FLAGS}" ]] ;
            then
                slapcat_options="${CONF_BACKUP_OPENLDAP_FLAGS} -l"
            else
                slapcat_options="-l"
            fi

            if [[ ( -n "${CONF_BACKUP_OPENLDAP_USER}" && -n "${CONF_BACKUP_OPENLDAP_GROUP}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_OPENLDAP_USER} -g ${CONF_BACKUP_OPENLDAP_GROUP} -H "${SLAPCAT}" ${slapcat_options} "${dump_file}"
                rc=$?
            elif [[ ( -n "${CONF_BACKUP_OPENLDAP_USER}" ) ]] ;
            then
                "${SUDO}" -u ${CONF_BACKUP_OPENLDAP_USER} -H "${SLAPCAT}" ${slapcat_options} "${dump_file}"
                rc=$?
            else
                "${SLAPCAT}" ${slapcat_options} "${dump_file}"
                rc=$?
            fi

            if [[ ${rc} -eq 0 ]] ;
            then
                archive "OpenLDAP objects and directories" "${CONF_BACKUP_OPENLDAP_TAG}" "${backup_name}" "${E_NO}" "${E_YES}" "${E_YES}" "${E_YES}" "${E_YES}"
                rc=$?

                case ${rc} in
                0)
                    logSuccess "'OpenLDAP backup completed successfully."
                    ;;
                1)
                    logWarning "OpenLDAP backup was only partially successful!"
                    REPORTS_STATUS="${ERROR_TAG}"
                    ;;
                *)
                    logError "OpenLDAP backup failed!"
                esac
            else
                logCommandReturnCode "slapcat" ${rc}
                logError "OpenLDAP dump failed!"
                logError "OpenLDAP backup failed!"
                log "${dump_dir} remains intact for your inspection."
            fi
        else
            logError "OpenLDAP backup failed!"
        fi
    else
        logError "OpenLDAP backup failed!"
    fi
}


function backupDatabases()
{
    local db_type="${1}"

    if [[ "${db_type}" != "${E_POSTGRES}"
            && "${db_type}" != "${E_MYSQL}" ]] ;
    then
        logError "Invalid database type '${db_type}'!"
        return
    fi

    local db_array_type=${db_type^^}
    local length

    eval "length=\${CONF_BACKUP_DATABASE_${db_array_type}_DATABASES}"

    case "${db_type}" in
    "${E_POSTGRES}")
        if [[ "${length}" -le 0 ]] ;
        then
            logError "Cannot find any PostgreSQL database to backup!"
            return
        fi
        ;;
    "${E_MYSQL}")
        if [[ "${length}" -le 0 ]] ;
        then
            logError "Cannot find any MariaDB / MySQL database to backup!"
            return
        fi
        ;;
    esac

    local rc
    local db_array_name
    local tag
    local name
    local comment
    local index

    for (( index = 0; index < ${length}; ++index ))
    do
        eval "db_array_name=CONF_BACKUP_DATABASE_${db_array_type}_DATABASE_${index}"
        eval "tag=\${${db_array_name}['tag']}"
        eval "name=\${${db_array_name}['name']}"
        eval "comment=\${${db_array_name}['comment']}"

        if [[ "${name}" == "${E_ASTERISK}" ]] ;
        then
            name="'${E_ASTERISK}'"
        fi

        log "Creating a backup from '${comment}'..."

        local backup_name="${CONF_BACKUP_ARCHIVE_NAME//'{DATE}'/${BACKUP_DATE}}"
        backup_name="${backup_name//'{TIME}'/${BACKUP_TIME}}"
        backup_name="${backup_name//'{HOST_NAME}'/${BACKUP_HOST_NAME}}"
        backup_name="${backup_name//'{TAG}'/${tag}}"

        local dump_dir="${CONF_TEMP_DIR}/${backup_name}"
        local dump_file="${dump_dir}/${tag}.sql"

        makeDirectory "${dump_dir}"
        rc=$?

        if [[ ${rc} -eq 0 ]] ;
        then
            case "${db_type}" in
            "${E_POSTGRES}")
                changeOwnership "${dump_dir}" "${E_YES}" "${CONF_BACKUP_DATABASE_POSTGRES_USER}" "${CONF_BACKUP_DATABASE_POSTGRES_GROUP}"
                rc=$?
                ;;
            "${E_MYSQL}")
                changeOwnership "${dump_dir}" "${E_YES}" "${CONF_BACKUP_DATABASE_MYSQL_USER}" "${CONF_BACKUP_DATABASE_MYSQL_GROUP}"
                rc=$?
                ;;
            esac

            if [[ ${rc} -eq 0 ]] ;
            then
                log "Dumping '${db_type}::${name}' to '${dump_file}'..."
                dumpDatabase "${db_type}" "${name}" "${dump_file}"
                rc=$?

                if [[ ${rc} -eq 0 ]] ;
                then
                    archive "${comment}" "${tag}" "${backup_name}" "${E_NO}" "${E_YES}" "${E_YES}" "${E_YES}" "${E_YES}"
                    rc=$?

                    case ${rc} in
                    0)
                        logSuccess "'${comment}' backup completed successfully."
                        ;;
                    1)
                        logWarning "'${comment}' backup was only partially successful!"
                        REPORTS_STATUS="${ERROR_TAG}"
                        ;;
                    *)
                        logError "'${comment}' backup failed!"
                    esac
                else
                    log "${dump_dir} remains intact for your inspection."
                    logError "'${comment}' backup failed!"
                fi
            else
                logError "'${comment}' backup failed!"
            fi
        else
            logError "'${comment}' backup failed!"
        fi
    done
}

function backupDatabase()
{
    local length=${#CONF_BACKUP_DATABASE_PRIORITY_ORDER[@]}

    if [[ "${length}" -le 0 ]] ;
    then
        logWarning "No database backup tasks to proceed."
        return
    fi

    local index
    for (( index = 0; index < ${length}; ++index ))
    do
        local item=${CONF_BACKUP_DATABASE_PRIORITY_ORDER[$index]}

        case "${item}" in
        "${E_POSTGRES}" | "${E_MYSQL}")
            backupDatabases "${item}"
            ;;
        *)
            logError "Invalid option '${item}'!"
        esac
    done

    logInfo "All database backup tasks finished."
}


function backupFilesystem()
{
    if [[ "${CONF_BACKUP_FILESYSTEM}" -le 0 ]] ;
    then
        logError "Cannot find any filesystem path to backup!"
        return
    fi

    local rc
    local filesystem_array_name
    local tag
    local path
    local follow_symlinks
    local comment
    local index

    for (( index = 0; index < ${CONF_BACKUP_FILESYSTEM}; ++index ))
    do
        eval "filesystem_array_name=CONF_BACKUP_FILESYSTEM_${index}"
        eval "tag=\${${filesystem_array_name}['tag']}"
        eval "path=\${${filesystem_array_name}['path']}"
        eval "follow_symlinks=\${${filesystem_array_name}['follow_symlinks']}"
        eval "comment=\${${filesystem_array_name}['comment']}"

        if [[ "${follow_symlinks}" != "${E_YES}" && "${follow_symlinks}" != "${E_NO}" ]] ;
        then
            logError "Invalid option '${follow_symlinks}'!"
            continue
        fi

        log "Creating a backup from '${comment}'..."

        archive "${comment}" "${tag}" "${path}" "${follow_symlinks}" "${E_NO}" "${E_NO}" "${E_NO}" "${E_NO}"
        rc=$?

        case ${rc} in
        0)
            logSuccess "'${comment}' backup completed successfully."
            ;;
        1)
            logWarning "'${comment}' backup was only partially successful!"
            REPORTS_STATUS="${ERROR_TAG}"
            ;;
        *)
            logError "'${comment}' backup failed!"
        esac
    done
}


function backupMisc()
{
    if [[ "${CONF_BACKUP_MISC}" -le 0 ]] ;
    then
        logError "Cannot find any misc task to run and backup to backup!"
        return
    fi

    local rc
    local tag
    local command_
    local args
    local path
    local follow_symlinks
    local remove_path_when_done
    local comment
    local index

    for (( index = 0; index < ${CONF_BACKUP_MISC}; ++index ))
    do
        eval "misc_array_name=CONF_BACKUP_MISC_${index}"
        eval "tag=\${${misc_array_name}['tag']}"
        eval "command_=\${${misc_array_name}['command']}"
        eval "args=\${${misc_array_name}['args']}"
        eval "path=\${${misc_array_name}['path']}"
        eval "follow_symlinks=\${${misc_array_name}['follow_symlinks']}"
        eval "remove_path_when_done=\${${misc_array_name}['remove_path_when_done']}"
        eval "comment=\${${misc_array_name}['comment']}"

        if [[ ( "${follow_symlinks}" != "${E_YES}" && "${follow_symlinks}" != "${E_NO}" )
                && ( "${remove_path_when_done}" != "${E_YES}" && "${remove_path_when_done}" != "${E_NO}" ) ]] ;
        then
            logError "Invalid option '${follow_symlinks}'!"
            continue
        fi

        log "Running '${comment}'..."

        eval "'${command_}' ${args}"
        rc=$?

        if [[ ${rc} -eq 0 ]] ;
        then
            log "Creating a backup from '${comment}'..."

            if [[ -f "${path}" || -d "${path}" ]] ;
            then
                archive "${comment}" "${tag}" "${path}" "${follow_symlinks}" "${remove_path_when_done}" "${remove_path_when_done}" "${remove_path_when_done}" "${remove_path_when_done}"
                rc=$?

                if [[ ${rc} -eq 0 ]] ;
                then
                    logSuccess "'${comment}' backup completed successfully."
                else
                    logError "'${comment}' backup failed!"
                fi
            else
                logError "'${path}' does not exists!"
                logError "'${comment}' backup failed!"
            fi
        else
            logError "Running '${command_} ${args}' failed due to unknown problems!"
            logError "'${comment}' backup failed!"

            if [[ -f "${path}" || -d "${path}" ]] ;
            then
                log "${path} remains intact for your inspection."
            fi
        fi
    done
}


function initialize()
{
    INITIALIZED_CLEAN_UP_MODULE="${E_NO}"
    INITIALIZED_REPORTS_MODULE="${E_NO}"

    readonly SCRIPT="$( "${READLINK}" -f "${BASH_SOURCE[0]}" )"
    readonly SCRIPT_DIR="$( "${DIRNAME}" "${SCRIPT}" )"
    readonly SCRIPT_NAME="$( "${BASENAME}" "${SCRIPT}" )"

    blindInitialize

    readonly BACKUP_DATE="$( "${DATE}" +%Y-%m-%d )"
    readonly BACKUP_TIME="$( "${DATE}" +%H-%M-%S )"
    readonly BACKUP_HOST_NAME="$( "${HOSTNAME}" )"
    readonly BACKUP_TAG="backup.${BACKUP_DATE}.$$"
    readonly LOG_FILE="/var/tmp/${BACKUP_TAG}.log"

    if [[ -d "${LOG_FILE}" || -f "${LOG_FILE}" ]] ;
    then
        removeFileOrDirectory "${LOG_FILE}"
        if [[ $? -ne 0 ]] ;
        then
            logFatal "Cannot remove existing log file '${LOG_FILE}'!"
        fi
    fi

    > "${LOG_FILE}"

    logInfo "This is ${APP_NAME} v${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}.${APP_VERSION_PATCH}."


    log "Initiating the backup process '${SCRIPT}'..."
    initializeCommands "readlink" "dirname" "basename"


    log "Initiating 'Logger' module..."
    initializeCommands "echo" "cut" "logger"
    logInfo "'Logger' module initialized successfully."
    logInfo "Writing logs to '${LOG_FILE}'."


    if [[ "${#BASH_ARGV[@]}" -ne 0 ]] ;
    then
        logFatal "'${SCRIPT}' accepts no argument!"
    fi


    log "Initiating 'Config' module..."

    local foundConfigFile=${E_NO}

    if [[ "${#CONFIG_DIRS[@]}" -gt 0 ]] ;
    then
        for path in "${CONFIG_DIRS[@]}" ;
        do
            eval path=${path}
            if [[ ! -z "${path}" ]] ;
            then
                logInfo "Looking for '${CONFIG_FILE}' inside '${path}'..."
                if [[ -f "${path}/${CONFIG_FILE}" ]] ;
                then
                    foundConfigFile=${E_YES}
                    readonly CONFIG_FILE="${path}/${CONFIG_FILE}"
                    logInfo "Found '${CONFIG_FILE}'."
                    break
                else
                    logInfo "Cannot find '${CONFIG_FILE}' in ${path}."
                fi
            else
                logInfo "Looking for '${CONFIG_FILE}' in current directory..."
                if [[ -f "${SCRIPT_DIR}/${CONFIG_FILE}" ]] ;
                then
                    foundConfigFile=${E_YES}
                    readonly CONFIG_FILE="${SCRIPT_DIR}/${CONFIG_FILE}"
                    logInfo "Found '${CONFIG_FILE}'."
                    break;
                else
                    logInfo "Cannot find '${CONFIG_FILE}' in current directory."
                fi
            fi
        done
    else
        logInfo "Looking for '${CONFIG_FILE}' in current directory..."
        if [[ -f "${SCRIPT_DIR}/${CONFIG_FILE}" ]] ;
        then
            foundConfigFile=${E_YES}
            readonly CONFIG_FILE="${SCRIPT_DIR}/${CONFIG_FILE}"
            logInfo "Found '${CONFIG_FILE}'."
        else
            logInfo "Cannot find '${CONFIG_FILE}' in current directory."
        fi
    fi

    if [[ "${foundConfigFile}" = "${E_YES}" ]] ;
    then
        logInfo "Using '${CONFIG_FILE}'..."
    else
        configParseError "'${CONFIG_FILE}' does not exists!"
    fi
    unset foundConfigFile


    initializeCommands "cat" "jq"
    logInfo "'Config' module initialized successfully."


    log "Translating status codes to message..."

    local rc

    local ifs="${IFS}"
    IFS=' '
    local commands
    commands=( $( < "${CONFIG_FILE}" jq --raw-output '.command | keys | join(" ")' ) )
    rc=$?
    IFS="${ifs}"
    unset ifs

    if [[ ${rc} -eq 0 ]] ;
    then
        local return_codes
        local message
        for cmd in "${commands[@]}" ;
        do
            local ifs="${IFS}"
            IFS=' '
            return_codes=( $( < "${CONFIG_FILE}" ${JQ} --raw-output ".command.${cmd}.return_code | keys | join(\" \")" ) )
            rc=$?
            IFS="${ifs}"
            unset ifs

            if [[ ${rc} -eq 0 ]] ;
            then
                local rc_hash="CONF_COMMAND_${cmd^^}_RETURN_CODES"
                declare -g -A ${rc_hash}

                for rc in "${return_codes[@]}" ;
                do
                    jsonValue message ".command.${cmd}.return_code.${rc}"
                    eval "${rc_hash}+=( ['${rc}']='${message}' )"
                done
                unset cmd_hash
            else
                configParseError "Cannot extract commands status codes from '${CONFIG_FILE}'"
            fi
        done
        unset return_codes
        unset message
    else
        configParseError "Cannot extract commands status codes from '${CONFIG_FILE}'"
    fi
    unset commands
    unset rc

    logInfo "Successfully translated status codes to message."


    log "Initiating 'Clean up' module..."
    initializeCommands "chown" "mkdir" "rm"

    jsonValue CONF_TEMP_DIR ".temp_dir"
    readonly CONF_TEMP_DIR="$( eval ${ECHO} ${CONF_TEMP_DIR//>} )/${BACKUP_TAG}"

    if [[ -d "${CONF_TEMP_DIR}" || -f "${CONF_TEMP_DIR}" ]] ;
    then
        removeFileOrDirectory "${CONF_TEMP_DIR}"
        if [[ $? -ne 0 ]] ;
        then
            logFatal "Cannot remove existing temporary directory '${CONF_TEMP_DIR}'!"
        fi
    fi

    makeDirectory "${CONF_TEMP_DIR}"
    if [[ $? -ne 0 ]] ;
    then
        logFatal "Cannot create temporary directory!"
    fi

    changeDirectory "${CONF_TEMP_DIR}"
    if [[ $? -ne 0 ]] ;
    then
        logFatal "Cannot change current path to temporary directory!"
    fi

    logInfo "Temp directory '${CONF_TEMP_DIR}' has been created and ready."
    readonly INITIALIZED_CLEAN_UP_MODULE="${E_YES}"
    logInfo "'Clean up' module initialized successfully."


    log "Initiating 'Reports' module..."

    local has_reports
    jsonHas has_reports "reports"

    if [[ "${has_reports}" != "${E_TRUE}" ]] ;
    then
        configParseError "There is no configuration specified for '.reports' in '${CONFIG_FILE}'!"
    fi
    unset has_reports

    jsonLength CONF_REPORTS_MAILBOXES ".reports.mailboxes"

    if [[ ${CONF_REPORTS_MAILBOXES} -gt 0 ]] ;
    then
        local email_address
        local attach_passphrases
        local index

        for (( index = 0; index < ${CONF_REPORTS_MAILBOXES}; ++index ))
        do
            jsonValue email_address ".reports.mailboxes[${index}].email_address"
            jsonValue attach_passphrases ".reports.mailboxes[${index}].attach_passphrases"

            if [[ ! "${email_address}" =~ $EMAIL_ADDRESS_REGEX ]] ;
            then
                configParseError "The reports recipient's email address '${mailbox}' is invalid!"
            fi

            verifyConfigOption "${attach_passphrases}" REPORTS_ATTACH_PASSPHRASES_OPTIONS[@]

            eval "declare -g -A CONF_REPORTS_MAILBOX_${index}=( ['email_address']='${email_address}' ['attach_passphrases']='${attach_passphrases}' )"
        done
        unset index
        unset mailbox
    else
    echo
        configParseError "There is no recipient's email address specified for reports in '${CONFIG_FILE}'!"
    fi

    jsonValue CONF_REPORTS_SUBJECT_SUCCESS '.reports.subject.success'
    jsonValue CONF_REPORTS_SUBJECT_ERROR '.reports.subject.error'
    jsonValue CONF_REPORTS_SUBJECT_FATAL '.reports.subject.fatal'
    jsonValue CONF_REPORTS_SUPPORT_INFO '.reports.support_info'

    CONF_REPORTS_SUBJECT_SUCCESS="${CONF_REPORTS_SUBJECT_SUCCESS//'{HOST_NAME}'/${BACKUP_HOST_NAME}}"
    CONF_REPORTS_SUBJECT_SUCCESS="${CONF_REPORTS_SUBJECT_SUCCESS//'{DATE}'/${BACKUP_DATE}}"
    readonly CONF_REPORTS_SUBJECT_SUCCESS="${CONF_REPORTS_SUBJECT_SUCCESS//'{TIME}'/${BACKUP_TIME}}"
    CONF_REPORTS_SUBJECT_ERROR="${CONF_REPORTS_SUBJECT_ERROR//'{HOST_NAME}'/${BACKUP_HOST_NAME}}"
    CONF_REPORTS_SUBJECT_ERROR="${CONF_REPORTS_SUBJECT_ERROR//'{DATE}'/${BACKUP_DATE}}"
    readonly CONF_REPORTS_SUBJECT_ERROR="${CONF_REPORTS_SUBJECT_ERROR//'{TIME}'/${BACKUP_TIME}}"
    CONF_REPORTS_SUBJECT_FATAL="${CONF_REPORTS_SUBJECT_FATAL//'{HOST_NAME}'/${BACKUP_HOST_NAME}}"
    CONF_REPORTS_SUBJECT_FATAL="${CONF_REPORTS_SUBJECT_FATAL//'{DATE}'/${BACKUP_DATE}}"
    readonly CONF_REPORTS_SUBJECT_FATAL="${CONF_REPORTS_SUBJECT_FATAL//'{TIME}'/${BACKUP_TIME}}"

    initializeCommands "mail" "printf"
    REPORTS_STATUS="${SUCCESS_TAG}"
    readonly INITIALIZED_REPORTS_MODULE="${E_YES}"

    logInfo "'Reports' module initialized successfully."


    initializeCommands 'flock'
    log "Trying to acquire the lock '${LOCK_FILE}'..."
    acquireLock
    if [[ $? -eq 0 ]] ;
    then
        logInfo "Successfully acquired the lock."
    else
        logFatal "Another instance of ${APP_NAME} is running!"
    fi


    log "Initiating 'Compression' module..."

    local has_compression
    jsonHas has_compression "compression"

    if [[ "${has_compression}" != "${E_TRUE}" ]] ;
    then
        configParseError "There is no configuration specified for '.compression' in '${CONFIG_FILE}'!"
    fi
    unset has_compression

    jsonValue CONF_COMPRESSION_ALGORITHM ".compression.algorithm"
    verifyConfigOption "${CONF_COMPRESSION_ALGORITHM}" COMPRESSION_ALGORITHM_OPTIONS[@]

    if [[ -n "${CONF_COMPRESSION_ALGORITHM}" ]] ;
    then
        jsonValue CONF_COMPRESSION_LEVEL ".compression.level"

        case "${CONF_COMPRESSION_ALGORITHM}" in
        "${E_LZMA2}")
            verifyConfigOption "${CONF_COMPRESSION_LEVEL}" COMPRESSION_LEVEL_LZMA2_OPTIONS[@]
            ;;
        "${E_GZIP}")
            verifyConfigOption "${CONF_COMPRESSION_LEVEL}" COMPRESSION_LEVEL_GZIP_OPTIONS[@]
            ;;
        "${E_BZIP2}")
            verifyConfigOption "${CONF_COMPRESSION_LEVEL}" COMPRESSION_LEVEL_BZIP2_OPTIONS[@]
            ;;
        esac
    fi

    jsonValue CONF_COMPRESSION_PRESERVE_PERMISSIONS ".compression.preserve_permissions"
    verifyConfigOption "${CONF_COMPRESSION_PRESERVE_PERMISSIONS}" COMPRESSION_PRESERVE_PERMISSIONS_OPTIONS[@]

    initializeCommands "tar"
    readonly TAR_OPTION_FOLLOW_SYMLINKS="--dereference"

    case "${CONF_COMPRESSION_ALGORITHM}" in
    "${E_LZMA2}")
        initializeCommands "xz"
        readonly ARCHIVE_EXTENSION="tar.xz"
        readonly ARCHIVE_COMPRESSOR="${XZ}"
        readonly ARCHIVE_COMPRESSOR_OPTIONS="-${CONF_COMPRESSION_LEVEL} -c -"
        readonly ARCHIVE_COMPRESSOR_NAME="xz"
        ;;
    "${E_GZIP}")
        initializeCommands "gzip"
        readonly ARCHIVE_EXTENSION="tar.gz"
        readonly ARCHIVE_COMPRESSOR="${GZIP}"
        readonly ARCHIVE_COMPRESSOR_OPTIONS="-${CONF_COMPRESSION_LEVEL} -"
        readonly ARCHIVE_COMPRESSOR_NAME="gzip"
        ;;
    "${E_BZIP2}")
        initializeCommands "bzip2"
        readonly ARCHIVE_EXTENSION="tar.bz2"
        readonly ARCHIVE_COMPRESSOR="${BZIP2}"
        readonly ARCHIVE_COMPRESSOR_OPTIONS="-${CONF_COMPRESSION_LEVEL} -"
        readonly ARCHIVE_COMPRESSOR_NAME="bzip2"
        ;;
    *)
        readonly ARCHIVE_EXTENSION="tar"
        readonly ARCHIVE_COMPRESSOR=
        readonly ARCHIVE_COMPRESSOR_NAME=
    esac

    if [[ "${CONF_COMPRESSION_PRESERVE_PERMISSIONS}" == "${E_YES}" ]] ;
    then
        if [[ -n "${CONF_COMPRESSION_ALGORITHM}" ]] ;
        then
            TAR_OPTIONS="-cpf -"
        else
            TAR_OPTIONS="-cpf"
        fi
    else
        if [[ -n "${CONF_COMPRESSION_ALGORITHM}" ]] ;
        then
            TAR_OPTIONS="-cf -"
        else
            TAR_OPTIONS="-cf"
        fi
    fi

    logInfo "'Compression' module initialized successfully."


    log "Initiating 'Security' module..."

    local has_security
    jsonHas has_security "security"

    if [[ "${has_security}" != "${E_TRUE}" ]] ;
    then
        configParseError "There is no configuration specified for '.security' in '${CONFIG_FILE}'!"
    fi
    unset has_security

    jsonValue CONF_SECURITY_CHECKSUM_ALGORITHM ".security.checksum_algorithm"
    verifyConfigOption "${CONF_SECURITY_CHECKSUM_ALGORITHM}" SECURITY_CHECKSUM_ALGORITHM_OPTIONS[@]

    jsonValue CONF_SECURITY_ENCRYPTION_ENABLE ".security.encryption.enable"
    verifyConfigOption "${CONF_SECURITY_ENCRYPTION_ENABLE}" SECURITY_ENCRYPTION_ENABLE_OPTIONS[@]

    jsonValue CONF_SECURITY_ENCRYPTION_KEY_SIZE ".security.encryption.key_size"
    verifyConfigOption "${CONF_SECURITY_ENCRYPTION_KEY_SIZE}" SECURITY_ENCRYPTION_KEY_SIZE_OPTIONS[@]

    if [[ "${CONF_SECURITY_ENCRYPTION_ENABLE}" == "${E_YES}" ]] ;
    then
        jsonValue CONF_SECURITY_ENCRYPTION_BASE64_ENCODE ".security.encryption.base64_encode"
        verifyConfigOption "${CONF_SECURITY_ENCRYPTION_BASE64_ENCODE}" SECURITY_ENCRYPTION_BASE64_ENCODE_OPTIONS[@]

        jsonValue CONF_SECURITY_ENCRYPTION_PRIVATE_KEY ".security.encryption.private_key"

        if [[ -n "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}" ]] ;
        then
            CONF_SECURITY_ENCRYPTION_PRIVATE_KEY="$( eval ${ECHO} ${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY//>} )"

            if [[ ! -f "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}" ]] ;
            then
                logFatal "'${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}' does not exists!"
            fi

            verifyPrivateKeyFormat "${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}"
            if [[ $? -ne 0 ]] ;
            then
                logFatal "'${CONF_SECURITY_ENCRYPTION_PRIVATE_KEY}' is not a valid RSA private key!"
            fi
        fi

        jsonValue CONF_SECURITY_ENCRYPTION_PASSPHRASE ".security.encryption.passphrase"
        jsonValue CONF_SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_LENGTH ".security.encryption.random_passphrase_length"

        if [[ ! ${CONF_SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_LENGTH} =~ ${NATURAL_NUMBER_REGEX} ]] ;
        then
            configParseError "'${CONF_SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_LENGTH}' for '.security.encryption.random_passphrase_length' is not a valid number!"
        fi

        jsonValue CONF_SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_PATTERN ".security.encryption.random_passphrase_pattern"
        verifyConfigOption "${CONF_SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_PATTERN}" SECURITY_ENCRYPTION_RANDOM_PASSPHRASE_PATTERN_OPTIONS[@]

        if [[ -z "${CONF_SECURITY_ENCRYPTION_PASSPHRASE}" ]] ;
        then
            initializeCommands "grep" "head" "strings" "tr"
        fi
    fi

    readonly CHECKSUM_EXTENSION="sum"
    readonly SIGNATURE_EXTENSION="sign"
    readonly SECRET_KEY_EXTENSION="key"
    readonly ENCRYPTED_ARCHIVE_EXTENSION="crypt"
    readonly ENCRYPTED_SECRET_KEY_EXTENSION="secret"

    initializeCommands "openssl"
    logInfo "'Security' module initialized successfully."


    log "Initiating 'Remote' module..."

    local has_remote
    jsonHas has_remote "remote"

    if [[ "${has_remote}" != "${E_TRUE}" ]] ;
    then
        logWarning "There is no configuration specified for '.remote' in '${CONFIG_FILE}'!"
        logWarning "All backups will be kept locally!"
    fi
    unset has_remote

    jsonValue CONF_REMOTE_KEEP_BACKUP_LOCALLY '.remote.keep_backup_locally'
    verifyConfigOption "${CONF_REMOTE_KEEP_BACKUP_LOCALLY}" REMOTE_KEEP_BACKUP_LOCALLY_OPTIONS[@]

    local has_servers
    jsonHas has_servers "servers" ".remote"

    if [[ "${has_servers}" != "${E_TRUE}" ]] ;
    then
        logWarning "There is no configuration specified for '.remote.servers' in '${CONFIG_FILE}'!"
        logWarning "All backups will be kept locally!"
    fi
    unset has_servers

    jsonLength CONF_REMOTE_SERVERS ".remote.servers"

    if [[ ${CONF_REMOTE_SERVERS} -gt 0 ]] ;
    then
        local remote_host
        local remote_port
        local remote_user
        local remote_dir
        local public_key
        local index

        for (( index = 0; index < ${CONF_REMOTE_SERVERS}; ++index ))
        do
            jsonValue remote_host ".remote.servers[${index}].host"
            jsonValue remote_port ".remote.servers[${index}].port"
            jsonValue remote_user ".remote.servers[${index}].user"
            jsonValue remote_dir ".remote.servers[${index}].dir"
            jsonValue backups_to_preserve ".remote.servers[${index}].backups_to_preserve"
            jsonValue public_key ".remote.servers[${index}].public_key"

            if [[ ! ${backups_to_preserve} =~ ${NUMBER_REGEX} ]] ;
            then
                configParseError "Expecting a number for '.remote.servers[${index}].backups_to_preserve'!"
            fi

            if [[ -n "${public_key}" ]] ;
            then
                public_key="$( eval ${ECHO} ${public_key//>} )"

                if [[ ! -f "${public_key}" ]] ;
                then
                    logFatal "'${public_key}' does not exists!"
                fi

                verifyPublicKeyFormat "${public_key}"
                if [[ $? -ne 0 ]] ;
                then
                    logFatal "'${public_key}' is not a valid RSA public key!"
                fi
            fi

            remote_dir="${remote_dir//'{HOST_NAME}'/${BACKUP_HOST_NAME}}"

            eval "declare -g -A CONF_REMOTE_SERVER_${index}=( ['host']='${remote_host}' ['port']='${remote_port}' ['user']='${remote_user}' ['dir']='${remote_dir}' ['backups_to_preserve']='${backups_to_preserve}' ['public_key']='${public_key}' )"
        done
        unset index
        unset remote_host
        unset remote_port
        unset remote_user
        unset remote_dir
        unset public_key
    fi

    initializeCommands 'du' 'expr' 'scp' 'ssh'
    logInfo "'Remote' module initialized successfully."


    log "Initiating 'Backup' module..."

    jsonValue CONF_BACKUP_ARCHIVE_NAME '.backup.archive_name'

    local has_priority_order
    jsonHas has_priority_order "priority_order" ".backup"

    if [[ "${has_priority_order}" != "${E_TRUE}" ]] ;
    then
        logError "There is no configuration specified for '.backup.priority_order' in '${CONFIG_FILE}'!"
        logWarning "Backup operation cannot be performed!"
    fi
    unset has_priority_order

    CONF_BACKUP_PRIORITY_ORDER=(  )

    local length
    jsonLength length ".backup.priority_order"

    if [[ ${length} -gt 0 ]] ;
    then
        local item
        local index

        for (( index = 0; index < ${length}; ++index ))
        do
            jsonValue item ".backup.priority_order[${index}]"

            if [[ "${item}" != "openldap" 
                    && "${item}" != "database"
                    && "${item}" != "filesystem"
                    && "${item}" != "misc" ]] ;
            then
                configParseError "Invalid option '${item}' for '.priority_order'!"
            fi

            CONF_BACKUP_PRIORITY_ORDER+=( ${item} )
        done
        unset index
        unset item
    else
        logError "There is no configuration specified for '.backup.priority_order' in '${CONFIG_FILE}'!"
        logWarning "Backup operation cannot be performed!"
    fi
    unset length


    local openldap
    jsonSelect openldap ".backup.priority_order[]" ". == \"openldap\""

    if [[ "${openldap}" == "openldap" ]] ;
    then
        log "Initiating 'OpenLDAP dump' module..."

        local has_openldap
        jsonHas has_openldap "openldap" ".backup"

        if [[ "${has_openldap}" != "${E_TRUE}" ]] ;
        then
            configParseError "There is no configuration specified for '.backup.openldap' in '${CONFIG_FILE}'!"
        fi
        unset has_openldap

        jsonValue CONF_BACKUP_OPENLDAP_TAG ".backup.openldap.tag"
        jsonValue CONF_BACKUP_OPENLDAP_USER ".backup.openldap.user"
        jsonValue CONF_BACKUP_OPENLDAP_GROUP ".backup.openldap.group"
        jsonValue CONF_BACKUP_OPENLDAP_FLAGS ".backup.openldap.flags"

        if [[ -z "${CONF_BACKUP_OPENLDAP_TAG}" ]] ;
        then
            logFatal "'.backup.openldap.tag' cannot be empty!"
        fi

        if [[ ( -n "${CONF_BACKUP_OPENLDAP_USER}" && -n "${CONF_BACKUP_OPENLDAP_GROUP}" )
                || ( -n "${CONF_BACKUP_OPENLDAP_USER}" ) ]] ;
        then
            initializeCommands 'sudo'
        elif [[ ( -z "${CONF_BACKUP_OPENLDAP_USER}" && -n "${CONF_BACKUP_OPENLDAP_GROUP}" ) ]] ;
        then
            logError "OpenLDAP group name is not sufficient! You should specify a user name for OpenLDAP along with the group name."
            logWarning "Ignoring OpenLDAP group!"
        fi

        initializeCommands 'slapcat'

        logInfo "'OpenLDAP dump' module initialized successfully."
    fi
    unset openldap


    local database
    jsonSelect database ".backup.priority_order[]" ". == \"database\""

    if [[ "${database}" == "database" ]] ;
    then
        log "Initiating 'Database dump' module..."

        local has_databases
        jsonHas has_database "database" ".backup"

        if [[ "${has_database}" != "${E_TRUE}" ]] ;
        then
            configParseError "There is no configuration specified for '.backup.database' in '${CONFIG_FILE}'!"
        fi
        unset has_database

        local has_priority_order
        jsonHas has_priority_order "priority_order" ".backup.database"

        if [[ "${has_priority_order}" != "${E_TRUE}" ]] ;
        then
            logError "There is no configuration specified for '.backup.database.priority_order' in '${CONFIG_FILE}'!"
            logWarning "Database backup operation cannot be performed!"
        fi
        unset has_priority_order

        CONF_BACKUP_DATABASE_PRIORITY_ORDER=(  )

        local length
        jsonLength length ".backup.database.priority_order"

        if [[ ${length} -gt 0 ]] ;
        then
            local item
            local index

            for (( index = 0; index < ${length}; ++index ))
            do
                jsonValue item ".backup.database.priority_order[${index}]"

                if [[ "${item}" != "postgres" 
                        && "${item}" != "mysql" ]] ;
                then
                    configParseError "Invalid option '${item}' for '.backup.database.priority_order'!"
                fi

                CONF_BACKUP_DATABASE_PRIORITY_ORDER+=( ${item} )
            done
            unset index
            unset item
        else
            logError "There is no configuration specified for '.backup.database.priority_order' in '${CONFIG_FILE}'!"
            logWarning "Database backup operation cannot be performed!"
        fi
        unset length

        local postgres
        jsonSelect postgres ".backup.database.priority_order[]" ". == \"postgres\""

        if [[ "${postgres}" == "postgres" ]] ;
        then
            log "Initiating 'PostgreSQL dump' module..."

            local has_postgres
            jsonHas has_postgres "postgres" ".backup.database"

            if [[ "${has_postgres}" != "${E_TRUE}" ]] ;
            then
                configParseError "There is no configuration specified for '.backup.database.postgres' in '${CONFIG_FILE}'!"
            fi
            unset has_postgres

            jsonValue CONF_BACKUP_DATABASE_POSTGRES_USER ".backup.database.postgres.user"
            jsonValue CONF_BACKUP_DATABASE_POSTGRES_GROUP ".backup.database.postgres.group"

            if [[ -z "${CONF_BACKUP_DATABASE_POSTGRES_USER}" ]] ;
            then
                configParseError "A system user is required to run PostgreSQL backup!"
            fi

            local has_databases
            jsonHas has_databases "databases" ".backup.database.postgres"

            if [[ "${has_databases}" != "${E_TRUE}" ]] ;
            then
                configParseError "There is no configuration specified for '.backup.database.postgres.databases' in '${CONFIG_FILE}'!"
            fi
            unset has_databases

            jsonLength CONF_BACKUP_DATABASE_POSTGRES_DATABASES ".backup.database.postgres.databases"

            if [[ ${CONF_BACKUP_DATABASE_POSTGRES_DATABASES} -gt 0 ]] ;
            then
                local tag
                local name
                local comment
                local index

                for (( index = 0; index < ${CONF_BACKUP_DATABASE_POSTGRES_DATABASES}; ++index ))
                do
                    jsonValue tag ".backup.database.postgres.databases[${index}].tag"
                    jsonValue name ".backup.database.postgres.databases[${index}].name"
                    jsonValue comment ".backup.database.postgres.databases[${index}].comment"

                    if [[ -z "${tag}" ]] ;
                    then
                        logFatal "'.backup.database.postgres.databases[${index}].tag' cannot be empty!"
                    fi

                    if [[ -z "${name}" ]] ;
                    then
                        logFatal "'.backup.database.postgres.databases[${index}].name' cannot be empty!"
                    fi

                    if [[ -z "${comment}" ]] ;
                    then
                        logFatal "'.backup.database.postgres.databases[${index}].comment' cannot be empty!"
                    fi

                    eval "declare -g -A CONF_BACKUP_DATABASE_POSTGRES_DATABASE_${index}=( ['tag']='${tag}' ['name']='${name}' ['comment']='${comment}' )"
                done
                unset index
                unset tag
                unset name
                unset comment

                initializeCommands 'sudo' 'pg_dump' 'pg_dumpall'
            else
                configParseError "There is no configuration specified for '.backup.database.postgres.databases' in '${CONFIG_FILE}'!"
            fi

            logInfo "'PostgreSQL dump' module initialized successfully."
        fi
        unset postgres

        local mysql
        jsonSelect mysql ".backup.database.priority_order[]" ". == \"mysql\""

        if [[ "${mysql}" == "mysql" ]] ;
        then
            log "Initiating 'MariaDB / MySQL dump' module..."

            local has_mysql
            jsonHas has_mysql "mysql" ".backup.database"

            if [[ "${has_mysql}" != "${E_TRUE}" ]] ;
            then
                configParseError "There is no configuration specified for '.backup.database.mysql' in '${CONFIG_FILE}'!"
            fi
            unset has_mysql

            jsonValue CONF_BACKUP_DATABASE_MYSQL_USER ".backup.database.mysql.user"
            jsonValue CONF_BACKUP_DATABASE_MYSQL_GROUP ".backup.database.mysql.group"

            if [[ ( -n "${CONF_BACKUP_DATABASE_MYSQL_USER}" && -n "${CONF_BACKUP_DATABASE_MYSQL_GROUP}" )
                    || ( -n "${CONF_BACKUP_DATABASE_MYSQL_USER}" ) ]] ;
            then
                initializeCommands 'sudo'
            elif [[ ( -z "${CONF_BACKUP_DATABASE_MYSQL_USER}" && -n "${CONF_BACKUP_DATABASE_MYSQL_GROUP}" ) ]] ;
            then
                logError "MariaDB / MySQL group name is not sufficient! You should specify a user name for MariaDB / MySQL along with the group name."
                logWarning "Ignoring MariaDB / MySQL group!"
            fi

            jsonValue CONF_BACKUP_DATABASE_MYSQL_INTERNAL_USER ".backup.database.mysql.internal_user"

            if [[ -z "${CONF_BACKUP_DATABASE_MYSQL_INTERNAL_USER}" ]] ;
            then
                configParseError "An internal MariaDB / Mysql user is required to run MariaDB / Mysql backup!"
            fi

            local has_databases
            jsonHas has_databases "databases" ".backup.database.mysql"

            if [[ "${has_databases}" != "${E_TRUE}" ]] ;
            then
                configParseError "There is no configuration specified for '.backup.database.mysql.databases' in '${CONFIG_FILE}'!"
            fi
            unset has_databases

            jsonLength CONF_BACKUP_DATABASE_MYSQL_DATABASES ".backup.database.mysql.databases"

            if [[ ${CONF_BACKUP_DATABASE_MYSQL_DATABASES} -gt 0 ]] ;
            then
                local tag
                local name
                local comment
                local index

                for (( index = 0; index < ${CONF_BACKUP_DATABASE_MYSQL_DATABASES}; ++index ))
                do
                    jsonValue tag ".backup.database.mysql.databases[${index}].tag"
                    jsonValue name ".backup.database.mysql.databases[${index}].name"
                    jsonValue comment ".backup.database.mysql.databases[${index}].comment"

                    if [[ -z "${tag}" ]] ;
                    then
                        logFatal "'.backup.database.mysql.databases[${index}].tag' cannot be empty!"
                    fi

                    if [[ -z "${name}" ]] ;
                    then
                        logFatal "'.backup.database.mysql.databases[${index}].name' cannot be empty!"
                    fi

                    if [[ -z "${comment}" ]] ;
                    then
                        logFatal "'.backup.database.mysql.databases[${index}].comment' cannot be empty!"
                    fi

                    eval "declare -g -A CONF_BACKUP_DATABASE_MYSQL_DATABASE_${index}=( ['tag']='${tag}' ['name']='${name}' ['comment']='${comment}' )"
                done
                unset index
                unset tag
                unset name
                unset comment

                initializeCommands 'mysqldump'
            else
                configParseError "There is no configuration specified for '.backup.database.mysql.databases' in '${CONFIG_FILE}'!"
            fi

            logInfo "'MariaDB / MySQL dump' module initialized successfully."
        fi
        unset mysql

        logInfo "'Database dump' module initialized successfully."
    fi
    unset database


    local filesystem
    jsonSelect filesystem ".backup.priority_order[]" ". == \"filesystem\""

    if [[ "${filesystem}" == "filesystem" ]] ;
    then
        log "Initiating 'Filesystem backup' module..."

        local has_filesystem
        jsonHas has_filesystem "filesystem" ".backup"

        if [[ "${has_filesystem}" != "${E_TRUE}" ]] ;
        then
            configParseError "There is no configuration specified for '.backup.filesystem' in '${CONFIG_FILE}'!"
        fi
        unset has_filesystem

        jsonLength CONF_BACKUP_FILESYSTEM ".backup.filesystem"

        if [[ ${CONF_BACKUP_FILESYSTEM} -gt 0 ]] ;
        then
            local tag
            local path
            local follow_symlinks
            local comment
            local index

            for (( index = 0; index < ${CONF_BACKUP_FILESYSTEM}; ++index ))
            do
                jsonValue tag ".backup.filesystem[${index}].tag"
                jsonValue path ".backup.filesystem[${index}].path"
                jsonValue follow_symlinks ".backup.filesystem[${index}].follow_symlinks"
                jsonValue comment ".backup.filesystem[${index}].comment"

                if [[ -z "${tag}" ]] ;
                then
                    logFatal "'.backup.filesystem[${index}].tag' cannot be empty!"
                fi

                if [[ -n "${path}" ]] ;
                then
                    path="$( eval ${ECHO} ${path//>} )"

                    if [[ ! -f "${path}" && ! -d "${path}" ]] ;
                    then
                        logError "'${path}' does not exists!"
                    fi
                else
                    logFatal "'.backup.filesystem[${index}].path' cannot be empty!"
                fi

                verifyConfigOption "${follow_symlinks}" FILESYSTEM_FOLLOW_SYMLINKS_OPTIONS[@]

                if [[ -z "${comment}" ]] ;
                then
                    logFatal "'.backup.filesystem[${index}].comment' cannot be empty!"
                fi

                eval "declare -g -A CONF_BACKUP_FILESYSTEM_${index}=( ['tag']='${tag}' ['path']='${path}' ['follow_symlinks']='${follow_symlinks}' ['comment']='${comment}' )"
            done
            unset index
            unset tag
            unset path
            unset follow_symlinks
            unset comment
        else
            configParseError "There is no configuration specified for '.backup.filesystem' in '${CONFIG_FILE}'!"
        fi

        logInfo "'Filesystem backup' module initialized successfully."
    fi
    unset filesystem


    local misc
    jsonSelect misc ".backup.priority_order[]" ". == \"misc\""

    if [[ "${misc}" == "misc" ]] ;
    then
        log "Initiating 'Misc backup' module..."

        local has_misc
        jsonHas has_misc "misc" ".backup"

        if [[ "${has_misc}" != "${E_TRUE}" ]] ;
        then
            configParseError "There is no configuration specified for '.backup.misc' in '${CONFIG_FILE}'!"
        fi
        unset has_misc

        jsonLength CONF_BACKUP_MISC ".backup.misc"

        if [[ ${CONF_BACKUP_MISC} -gt 0 ]] ;
        then
            local tag
            local command_
            local args
            local path
            local follow_symlinks
            local remove_path_when_done
            local comment
            local index

            for (( index = 0; index < ${CONF_BACKUP_MISC}; ++index ))
            do
                jsonValue tag ".backup.misc[${index}].tag"
                jsonValue command_ ".backup.misc[${index}].command"
                jsonValue args ".backup.misc[${index}].args"
                jsonValue path ".backup.misc[${index}].path"
                jsonValue follow_symlinks ".backup.misc[${index}].follow_symlinks"
                jsonValue remove_path_when_done ".backup.misc[${index}].remove_path_when_done"
                jsonValue comment ".backup.misc[${index}].comment"

                if [[ -z "${tag}" ]] ;
                then
                    logFatal "'.backup.misc[${index}].tag' cannot be empty!"
                fi

                if [[ -n "${command_}" ]] ;
                then
                    command_="$( eval ${ECHO} ${command_//>} )"

                    if [[ ! -f "${command_}" ]] ;
                    then
                        logError "'${command_}' does not exists!"
                    fi
                else
                    logFatal "'.backup.misc[${index}].command' cannot be empty!"
                fi

                if [[ -z "${path}" ]] ;
                then
                    logFatal "'.backup.misc[${index}].path' cannot be empty!"
                fi

                verifyConfigOption "${follow_symlinks}" MISC_FOLLOW_SYMLINKS_OPTIONS[@]
                verifyConfigOption "${remove_path_when_done}" MISC_REMOVE_PATH_WHEN_DONE_OPTIONS[@]

                if [[ -z "${comment}" ]] ;
                then
                    logFatal "'.backup.misc[${index}].comment' cannot be empty!"
                fi

                eval "declare -g -A CONF_BACKUP_MISC_${index}=( ['tag']='${tag}' ['command']='${command_}' ['args']='${args}' ['path']='${path}' ['follow_symlinks']='${follow_symlinks}' ['remove_path_when_done']='${remove_path_when_done}' ['comment']='${comment}' )"
           done
            unset index
            unset tag
            unset command_
            unset args
            unset path
            unset follow_symlinks
            unset remove_path_when_done
            unset comment
        else
            configParseError "There is no configuration specified for '.backup.misc' in '${CONFIG_FILE}'!"
        fi

        logInfo "'Misc backup' module initialized successfully."
    fi
    unset misc


    if [[ "${CONF_SECURITY_ENCRYPTION_ENABLE}" == "${E_YES}" ]] ;
    then
        if [[ "${CONF_SECURITY_ENCRYPTION_PASSPHRASE}" == "" ]] ;
        then
            local index
            local public_key
            local attach_passphrases
            local any_public_key="${E_NO}"
            local any_attach_passphrases="${E_NO}"

            for (( index = 0; index < ${CONF_REMOTE_SERVERS}; ++index ))
            do
                eval "public_key=\${CONF_REMOTE_SERVER_${index}['public_key']}"

                if [[ "${public_key}" != "" ]] ;
                then
                    any_public_key="${E_YES}"
                    break
                fi
            done

            for (( index = 0; index < ${CONF_REPORTS_MAILBOXES}; ++index ))
            do
                eval "attach_passphrases=\${CONF_REPORTS_MAILBOX_${index}['attach_passphrases']}"

                if [[ "${attach_passphrases}" == "${E_YES}" ]] ;
                then
                    any_attach_passphrases="${E_YES}"
                    break
                fi
            done

            if [[ "${any_public_key}" != "${E_YES}" && "${any_attach_passphrases}" != "${E_YES}" ]] ;
            then
                logError "Neither an email specified nor provided with a public key to attach or upload random passphrases!"
                logFatal "You chose random passphrases. But, how to recover random passphrases later on?"
            fi

            unset index
            unset public_key
            unset attach_passphrases
            unset any_public_key
            unset any_attach_passphrases
        fi
    fi


    logInfo "'Backup' module initialized successfully."
}


function cleanUpOldBackups() {
    if [[ ${CONF_REMOTE_SERVERS} -le 0 ]] ;
    then
        return
    fi

    local rc
    local remote_server_array_name
    local remote_host
    local remote_port
    local remote_user
    local remote_dir
    local backups_to_preserve
    local public_key
    local index

    for (( index = 0; index < ${CONF_REMOTE_SERVERS}; ++index ))
    do
        eval "remote_server_array_name=CONF_REMOTE_SERVER_${index}"
        eval "remote_host=\${${remote_server_array_name}['host']}"
        eval "remote_port=\${${remote_server_array_name}['port']}"
        eval "remote_user=\${${remote_server_array_name}['user']}"
        eval "remote_dir=\${${remote_server_array_name}['dir']}"
        eval "backups_to_preserve=\${${remote_server_array_name}['backups_to_preserve']}"
        eval "public_key=\${${remote_server_array_name}['public_key']}"

        if [[ -n "${public_key}" ]] ;
        then
            if [[ ! -f "${public_key}" ]] ;
            then
                logError "'${public_key}' does not exists!"
            fi

            verifyPublicKeyFormat "${public_key}"
            rc=$?

            if [[ $rc -ne 0 ]] ;
            then
                logFatal "'${public_key}' is not a valid RSA public key!"
            fi
        fi

        log "Checking if '${remote_user}@${remote_host}:${remote_port}/${remote_dir}' exists..."

        ${SSH} -p ${remote_port} ${remote_user}@${remote_host} "cd ${remote_dir} > /dev/null 2>&1"
        rc=$?

        case ${rc} in
        0)
            if [[ ${backups_to_preserve} -le 0 ]] ;
            then
                logInfo "'${remote_user}@${remote_host}:${remote_port}/${remote_dir}' exists."
                continue
            fi

            log "Cleaning up old backups at '${remote_user}@${remote_host}:${remote_port}/${remote_dir}'..."

            local remote_dirs
            remote_dirs=( $( "${SSH}" -p ${remote_port} ${remote_user}@${remote_host} "cd ${remote_dir} && ls -d */" ) )
            rc=$?

            if [[ ${rc} -eq 0 ]] ;
            then
                for dir in ${remote_dirs[*]} ;
                do
                    log "Cleaning up '${remote_user}@${remote_host}:${remote_port}/${remote_dir}/${dir}'..."
                    local remote_files
                    remote_files=( $( "${SSH}" -p ${remote_port} ${remote_user}@${remote_host} "ls ${remote_dir}/${dir}" ) )
                    rc=$?

                    if [[ ${rc} -eq 0 ]] ;
                    then
                        local files_to_erase_count
                        files_to_erase_count=$( ${EXPR} ${#remote_files[@]} - $( ${EXPR} ${backups_to_preserve} ) )

                        if [[ ${files_to_erase_count} -gt 0 ]] ;
                        then
                            ${SSH} -p ${remote_port} ${remote_user}@${remote_host} "find ${remote_dir}/${dir} | sort | tail -n+2 | head -n ${files_to_erase_count} | xargs rm -rf"
                            rc=$?

                            if [[ ${rc} -ne 0 ]] ;
                            then
                                logCommandReturnCode "ssh" ${rc}
                                logError "Cannot clean up '${remote_user}@${remote_host}:${remote_port}/${remote_dir}/${dir}'!"
                            fi
                        fi
                    else
                        logCommandReturnCode "ssh" ${rc}
                        logError "Cannot fetch list of remote files from '${remote_user}@${remote_host}:${remote_port}/${remote_dir}/${dir}'!"
                    fi
                done
            fi
            ;;
        1)
            log "Creating '${remote_user}@${remote_host}:${remote_port}/${remote_dir}'..."
            ${SSH} -p ${remote_port} ${remote_user}@${remote_host} "mkdir -p ${remote_dir} && cd ${remote_dir} > /dev/null 2>&1"
            rc=$?

            if [[ ${rc} -ne 0 ]] ;
            then
                logCommandReturnCode "ssh" ${rc}
                logError "Cannot connect to host ${remote_host}!"
            fi
            ;;
        *)
            logCommandReturnCode "ssh" ${rc}
            logError "Cannot connect to host ${remote_host}!"
        esac
    done
}


function backup() {
    local length=${#CONF_BACKUP_PRIORITY_ORDER[@]}

    if [[ "${length}" -le 0 ]] ;
    then
        logWarning "No backup tasks to proceed."
        return
    fi

    local index
    for (( index = 0; index < ${length}; ++index ))
    do
        local item=${CONF_BACKUP_PRIORITY_ORDER[$index]}

        case "${item}" in
        "openldap")
            backupLdap
            ;;
        "database")
            backupDatabase
            ;;
        "filesystem")
            backupFilesystem
            ;;
        "misc")
            backupMisc
            ;;
        *)
            logError "Invalid option '${item}'!"
        esac
    done

    logInfo "All backup tasks finished."
}


function cleanUp()
{
    if [[ "${INITIALIZED_CLEAN_UP_MODULE}" != "${E_YES}" ]] ;
    then
        return
    fi
    if [[ -n "${CONF_TEMP_DIR}" ]] ;
    then
        case "${REPORTS_STATUS}" in
        "${SUCCESS_TAG}")
            if [[ ${CONF_REMOTE_SERVERS} -gt 0 ]] ;
            then
                if [[ ${CONF_REMOTE_KEEP_BACKUP_LOCALLY} != "${E_SUCCESS}" ]] ;
                then
                    log "Cleaning up '${CONF_TEMP_DIR}'..."
                    removeFileOrDirectory "${CONF_TEMP_DIR}"
                    rc=$?

                    if [[ ${rc} -ne 0 ]] ;
                    then
                        logError "Cannot remove temporary directory!"
                    fi
                fi
            else
                logInfo "All backup files will be kept only locally inside '${CONF_TEMP_DIR}'."
            fi
            ;;
        "${ERROR_TAG}")
            logWarning "Due to some errors, all files inside '${CONF_TEMP_DIR}' - if there's any - remain intact for your inspection."
            ;;
        "${FATAL_TAG}")
            logWarning "Due to some fatal errors, all files inside '${CONF_TEMP_DIR}' - if there's any - remain intact for your inspection."
            ;;
        *)
            logWarning "Due to some unknown errors, all files inside '${CONF_TEMP_DIR}' - if there's any - remain intact for your inspection."
        esac
    fi
}


function sendReports()
{
    if [[ "${INITIALIZED_REPORTS_MODULE}" != "${E_YES}" ]] ;
    then
        return
    fi

    local seconds=$(( SECONDS % 60 ))
    local result=$(( SECONDS / 60 ))
    local minutes=$(( result % 60 ))
    result=$(( result / 60 ))
    local hours=$(( result % 24 ))
    local days=$(( result / 24 ))

    local duration

    if [[ ${days} -le 0 ]] ;
    then
        if [[ ${hours} -le 0 ]] ;
        then
            if [[ ${minutes} -le 0 ]] ;
            then
                duration="${seconds}s"
            else
                duration="${minutes}m ${seconds}s"
            fi
        else
            duration="${hours}h ${minutes}m ${seconds}s"
        fi
    else
        duration="${days}d ${hours}h ${minutes}m ${seconds}s"
    fi

    log "It took ${duration} to finish all backup tasks."
    logInfo "All backups by ${APP_NAME} v${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}.${APP_VERSION_PATCH}."

    local rc
    local log_file

    log_file=$( "${CAT}" "${LOG_FILE}" )

    if [[ ${rc} -eq 0 ]] ;
    then
        local subject

        case "${REPORTS_STATUS}" in
        "${SUCCESS_TAG}")
            subject=${CONF_REPORTS_SUBJECT_SUCCESS}
            ;;
        "${ERROR_TAG}")
            subject=${CONF_REPORTS_SUBJECT_ERROR}
            ;;
        "${FATAL_TAG}")
            subject=${CONF_REPORTS_SUBJECT_FATAL}
            ;;
        *)
            logError "Unknown report status '${REPORT_STATUS}'!"
            subject=${CONF_REPORTS_SUBJECT_FATAL}
        esac

        local rc
        local email_address
        local attach_passphrases
        local body

        for (( index = 0; index < ${CONF_REPORTS_MAILBOXES}; ++index ))
        do
            eval "reports_mailbox_array_name=CONF_REPORTS_MAILBOX_${index}"
            eval "email_address=\${${reports_mailbox_array_name}['email_address']}"
            eval "attach_passphrases=\${${reports_mailbox_array_name}['attach_passphrases']}"

            log "Sending reports via email to ${email_address}..."

            body=$( ${PRINTF} '%s\n\n%s' "${log_file}" "${CONF_REPORTS_SUPPORT_INFO}" )

            if [[ "${CONF_SECURITY_ENCRYPTION_ENABLE}" == "${E_YES}" ]] ;
            then
                if [[ "${attach_passphrases}" == "${E_YES}" ]] ;
                then
                    body=$( ${PRINTF} '%s\n\n\n%s' "${body}" "${REPORTS_PWD}" )
                fi
            fi

            "${PRINTF}" '%s' "${body}" | "${MAIL}" -s "${subject}" "${email_address}"
            rcs=( ${PIPESTATUS[*]} )

            if [[ ${rcs[0]} -eq 0 && ${rcs[1]} -eq 0 ]] ;
            then
                log "Backup reports was sent to ${email_address} successfully."
            else
                if [[ ${rcs[0]} -ne 0 ]] ;
                then
                    logCommandReturnCode "echo" ${rcs[0]}
                fi

                if [[ ${rcs[1]} -ne 0 ]] ;
                then
                    logCommandReturnCode "mail" ${rcs[1]}
                fi

                logError "Sending backup reports failed!"
            fi
        done
    else
        logCommandReturnCode "cat" ${rc}
        logError "Cannot prepare email body due to read errors from '${LOG_FILE}'!"
        logError "Sending backup reports failed!"
    fi
}


function main()
{
    initialize
    cleanUpOldBackups
    backup
    cleanUp
    sendReports
}


main


