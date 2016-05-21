#!/bin/bash

COL_RED="$(echo -e "\033[31m")"
COL_GREEN="$(echo -e "\033[32m")"
COL_YELLOW="$(echo -e "\033[33m")"
COL_RESET="$(echo -e "\033[0m")"

function echo_log {
  echo -e "[   Log   ] ${1}"
}

function echo_error {
  echo -e "${COL_RED}[  Error  ] ${1}${COL_RESET}"
}

function echo_success {
  echo -e "${COL_GREEN}[   Ok    ] ${1}${COL_RESET}"
}

function echo_warning {
  echo -e "${COL_YELLOW}[ Warning ] ${1}${COL_RESET}"
}

