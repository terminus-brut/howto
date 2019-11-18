def downstream_name = 'java-packaging-howto'

node() {
	stage('Checkout') {
		checkout scm
	}
	stage('Get commit message') {
		env.commit_message = sh(
			script: "echo 'Upstream commit:' `git log -1 --pretty=%B`",
			returnStdout: true
		)
	}
	stage('Build') {
		sh "echo ${commit_message}"
		sh "make antora"
	}
	stage('Deploy') {
		steps {
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
