#!/usr/bin/env bash

set -e
SYSPYTHON=python
VENV_OPTIONS=

package_name='matplotlib'
package_versions=('3.8.4') #Later versions cause meson problems.
for version in "${package_versions[@]}";do
    VENV_SUBDIR="./venv-${package_name}-${version}"
    echo "Creating ${VENV_SUBDIR}"
    ${SYSPYTHON} -m venv --upgrade-deps ${VENV_OPTIONS} ${VENV_SUBDIR}
    source "${VENV_SUBDIR}/bin/activate"
    echo "installing ${package_name} v: ${version}"
    pip install "${package_name}==${version}"
    deactivate
done
