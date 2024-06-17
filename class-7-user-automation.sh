#Check if the user already exists and create if not exists.
#Generate Random Password and assign to the user.
#Make sure user has sudo permissions.
#Expire the password forcing the user to reset it.

#!/bin/bash
SLACK_WEB='https://hooks.slack.com/services/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'
#USERNAME=$1
if [ $# -gt 0 ]; then
    for USERNAME in $@; do
        EXISTING_USER=$(cat /etc/passwd | grep -i -w ${USERNAME} | cut -d ':' -f 1)
        if [ "${USERNAME}" = "${EXISTING_USER}" ]; then
            echo "The User ${USERNAME} Already Exists. Try A Diffrent Username."
        else
            echo "Lets Create User ${USERNAME}."
            sudo useradd -m $USERNAME --shell /bin/bash -d /home/${USERNAME}
            sudo usermod -aG sudo ${USERNAME}
            echo '${USERNAME} ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers
            SPEC=$(echo '!@#$%^&*()_' | fold -w1 | shuf | head -1)
            PASSWORD="India@${RANDOM}${SPEC}"
            echo "${USERNAME}:${PASSWORD}" | sudo chpasswd
            passwd -e ${USERNAME}
            echo "The Temporary Credentails are ${USERNAME} and ${PASSWORD}"
            curl -X POST ${SLACK_WEB} -sL -H 'Content-type: application/json' --data "{"text": \"Username is: ${USERNAME}\"}" >>/dev/null
            curl -X POST ${SLACK_WEB} -sL -H 'Content-type: application/json' --data "{"text": \"Temporary Password Is: ${PASSWORD}  Reset This Password Immediatly.\"}" >>/dev/null

        fi
    done
else
    echo "You Have Given $# Arguments. Please Provide Atleast One Arg."
fi

#echo 'welcome-to-devsecops' | tr [::lower::] [::upper::]
#echo 'welcome-to-devsecops' | tr 'e' 'x'
#sed -i "58 s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config | grep -i passwordauthen -n
