# Intial setup of pyenv from github readme
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Auto activate python venvs if named .venv
python_activate_venv() {
  MYVENV=./.venv
  [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
  [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_activate_venv

python_activate_venv
