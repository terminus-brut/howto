def downstream_name = 'java-packaging-howto'

node() {
	stages {
		stage('Checkout') {
			checkout scm
		}
		stage('Install tools') {
			sh "yum -y install asciidoc dia javapackages-tools m4 make python3-ansi2html"
		}
		stage('Get commit message') {
			sh "pushd howto"
			env.commit_message = sh(
				script: "echo 'Upstream commit:' `git log -1 --pretty=%B`",
				returnStdout: true
			)
		}
		stage('Build') {
			steps {
				sh "make antora"
			}
		}
		stage('Deploy') {
			steps {
				sh "set -e"
				sh "git clone ssh://git@pagure.io/${downstream_name}.git"
				sh "rm -rf ${downstream_name} /modules"
				sh "mv modules ${downstream_name}"
				sh "pushd ${downstream_name}"
				sh "git add modules"
				sh "git commit -m ${commit_message}"
				sh "git push"
			}
		}
	}
}
