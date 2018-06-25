import jenkins.model.Jenkins
import hudson.security.SecurityRealm
import hudson.security.AuthorizationStrategy
import org.jenkinsci.plugins.GithubSecurityRealm
import org.jenkinsci.plugins.GithubAuthorizationStrategy

String githubWebUri = args[0]
String githubApiUri = args[1]
String clientID = args[2]
String clientSecret = args[3]
String oauthScopes = 'read:org,user:email'

SecurityRealm github_realm = new GithubSecurityRealm(githubWebUri, githubApiUri, clientID, clientSecret, oauthScopes)
//check for equality, no need to modify the runtime if no settings changed
if(!github_realm.equals(Jenkins.instance.getSecurityRealm())) {
    Jenkins.instance.setSlaveAgentPort(1339)
    Jenkins.instance.setSecurityRealm(github_realm)
    Jenkins.instance.save()
}
