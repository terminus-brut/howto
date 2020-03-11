def downstream_name = 'java-packaging-howto'

def on_duffy_node(String script)
{
	sh 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -l root ${DUFFY_NODE}.ci.centos.org "' + script + '"'
}

node()
{
	stage('Checkout')
	{
		checkout scm
	}
	stage('Get commit message')
	{
		env.commit_message = sh(
			script: "echo 'Upstream commit:' `git log -1 --pretty=%B`",
			returnStdout: true
		)
	}
	stage('Allocate Duffy node')
	{
		// Get a duffy node and set the DUFFY_NODE and SSID environment variables.
		duffy_rtn = sh(
			script: 'cico --debug node get -f value -c hostname -c comment --retry-count 16 --retry-interval 60',
			returnStdout: true
		).trim().tokenize(' ')
		env.DUFFY_NODE = duffy_rtn[0]
		env.SSID = duffy_rtn[1]
	}
	try
	{
		stage('Install tools')
		{
			on_duffy_node "sudo yum -y install asciidoc dia javapackages-tools m4 make python3-ansi2html"
		}
		stage('Build')
		{
			on_duffy_node "git clone git@github.com:fedora-java/howto.git"
			on_duffy_node "pushd howto"
			on_duffy_node "make antora"
			on_duffy_node "popd"
		}
		stage('Deploy')
		{
			on_duffy_node "git clone https://pagure.io/${downstream_name}.git"
			on_duffy_node "rm -rf ${downstream_name}/modules"
			on_duffy_node "mv howto/modules ${downstream_name}"
			on_duffy_node "pushd ${downstream_name}"
			on_duffy_node "git add modules"
			on_duffy_node "git commit -m ${commit_message}"
			on_duffy_node "git push origin master:test"
			on_duffy_node "popd"
		}
	}
	finally
	{
		stage('Deallocate node')
		{
			sh 'cico node done ${SSID}'
		}
	}
}
