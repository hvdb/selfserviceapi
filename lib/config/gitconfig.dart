library GitConfig;
/**
 * Class to hold all the configuration for the git repo used.
 * //TODO This should be made configurable
 */




final STASH_IP = '192.168.248.145';
final STASH_BASE_API_URL = 'http://'+STASH_IP+':7990/rest/api/1.0/';
final STASH_API_URL = STASH_BASE_API_URL + 'projects/AN/repos';
final STASH_SSH_URL = 'ssh://git@'+STASH_IP+':7999';