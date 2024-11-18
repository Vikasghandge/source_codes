###  here i have mentioned all steps how to intregrate jenkins with github using webhook how to how build docker file using jenkins and automatically send that image to the docker hub ###

### prequsites
docker server --> docker should be installed and that server.
jenkins server --> jenkins should be installed and aslo docker plugin or docker should installed.
docker hub --> you need one docker hub account to store docker images.  ### usename and passward

step -1 installation of jenkins 
link to install latest jenkins https://www.jenkins.io/doc/book/installing/linux/#debianubuntu

in below we are installing jenkins required plugins and dependinces.

```
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

### download requird java version

```
sudo apt update
sudo apt install fontconfig openjdk-17-jre
java -version
```

### start jenkins 

```
sudo systemctl enable jenkins
```

```
sudo systemctl start jenkins
```

```
sudo systemctl status jenkins
```

now take you jenkins server ip addresss -- 192.168.152.52:8080
login copy the give path and paste it into passwd.

add  username and passwd then add required plugins like docker .

step -2  first of all install docker on your serve.
then clone the repo then 
write a docker file and push it into the git repo.

intregrate jenkins with git webhok to trigger pipeline.

steps - go to git webkooh add their jenkims server ip http://<ip>/github-webook/
then add git credential into jenkins serves credeantials like username passwd.
then do one more thing take passwd/personal access token  and username of docker hub and add it jenkins server global creadentials 

make sure docker.sock should be requir permissions
''' 
chmod 666 /var/run/docker.sock
```

now last step is go the jenkins create new pipline add this type of syntax

```
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Vikasghandge/Docker.git'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t season_switcher_image ./season_switcher'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag season_switcher_image $DOCKER_USER/season_switcher_image:latest
                        docker push $DOCKER_USER/season_switcher_image:latest
                    '''
                }
            }
        }
    }
}
```












