library GitConfig;
/**
 * Library to hold all the configuration for the git repo used.
 */




String STASH_IP = '';
final STASH_BASE_API_URL = 'http://'+STASH_IP+':7990/rest/api/1.0/';
final STASH_API_URL = STASH_BASE_API_URL + 'projects/AN/repos';
final STASH_SSH_URL = 'http://admin:admin@'+STASH_IP+':7990/scm';

final STASH_ADD_REMOTE = 'http://admin@'+STASH_IP+':7990/scm';
