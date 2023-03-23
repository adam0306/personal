# coding: utf-8
# https://developers.google.com/youtube/v3/docs/subscriptions/list

import math
import os
import sys

import httplib2
from apiclient.discovery import build
from apiclient.errors import HttpError
from oauth2client.client import flow_from_clientsecrets
from oauth2client.file import Storage
from oauth2client.tools import argparser, run_flow

# The CLIENT_SECRETS_FILE variable specifies the name of a file that contains
# the OAuth 2.0 information for this application, including its client_id and
# client_secret. You can acquire an OAuth 2.0 client ID and client secret from
# the Google Developers Console at
# https://console.developers.google.com/.
# Please ensure that you have enabled the YouTube Data API for your project.
# For more information about using OAuth2 to access the YouTube Data API, see:
#   https://developers.google.com/youtube/v3/guides/authentication
# For more information about the client_secrets.json file format, see:
#   https://developers.google.com/api-client-library/python/guide/aaa_client_secrets
CLIENT_SECRETS_FILE = "client_secrets.json"

# This OAuth 2.0 access scope allows for full read/write access to the
# authenticated user's account.
YOUTUBE_READ_WRITE_SCOPE = "https://www.googleapis.com/auth/youtube"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

# This variable defines a message to display if the CLIENT_SECRETS_FILE is
# missing.
MISSING_CLIENT_SECRETS_MESSAGE = """
WARNING: Please configure OAuth 2.0

To make this sample run you will need to populate the client_secrets.json file
found at:

   {}

with information from the Developers Console
https://console.developers.google.com/

For more information about the client_secrets.json file format, please visit:
https://developers.google.com/api-client-library/python/guide/aaa_client_secrets
""".format(os.path.abspath(os.path.join(os.path.dirname(__file__),
                                        CLIENT_SECRETS_FILE)))


def retrieve_youtube_subscriptions():
    # In order to retrieve the YouTube subscriptions for the current user,
    # the user needs to authenticate and authorize access to their YouTube
    # subscriptions.
    youtube_authorization = get_authenticated_service()

    try:
        # init
        next_page_token = ''
        subs_iteration = 0
        while True:
            # retrieve the YouTube subscriptions for the authorized user
            subscriptions_response = youtube_subscriptions(youtube_authorization, next_page_token)
            subs_iteration += 1
            total_results = subscriptions_response['pageInfo']['totalResults']
            results_per_page = subscriptions_response['pageInfo']['resultsPerPage']
            total_iterations = math.ceil(total_results / results_per_page)
            print('Subscriptions iteration: {} of {} ({}%)'.format(subs_iteration,
                                                                   total_iterations,
                                                                   round(subs_iteration / total_iterations * 100),
                                                                   0))
            # get the token for the next page if there is one
            next_page_token = get_next_page(subscriptions_response)
            # extract the required subscription information
            channels = parse_youtube_subscriptions(subscriptions_response)
            # add the channels relieved to the main channel list
            all_channels.extend(channels)
            if not next_page_token:
                break
        return all_channels

    except HttpError as err:
        print("An HTTP error {} occurred:\n{}".format(err.resp.status, err.content))


def get_authenticated_service():
    # Create a Storage instance to store and retrieve a single
    # credential to and from a file. Used to store the
    # oauth2 credentials for the current python script.
    storage = Storage("{}-oauth2.json".format(sys.argv[0]))
    credentials = storage.get()

    # Validate the retrieved oauth2 credentials
    if credentials is None or credentials.invalid:
        # Create a Flow instance from a client secrets file
        flow = flow_from_clientsecrets(CLIENT_SECRETS_FILE,
                                       scope=YOUTUBE_READ_WRITE_SCOPE,
                                       message=MISSING_CLIENT_SECRETS_MESSAGE)
        # The run_flow method requires arguments.
        # Initial default arguments are setup in tools, and any
        # additional arguments can be added from the command-line
        # and passed into this method.
        args = argparser.parse_args()
        # Obtain valid credentials
        credentials = run_flow(flow, storage, args)

    # Build and return a Resource object for interacting with an YouTube API
    return build(YOUTUBE_API_SERVICE_NAME,
                 YOUTUBE_API_VERSION,
                 http=credentials.authorize(httplib2.Http()))


# Call youtube.subscriptions.list method
# to list the channels subscribed to.
def youtube_subscriptions(youtube, next_page_token):
    subscriptions_response = youtube.subscriptions().list(
        part='snippet',
        mine=True,
        maxResults=50,
        order='alphabetical',
        pageToken=next_page_token).execute()
    return subscriptions_response


def get_next_page(subscriptions_response):
    # check if the subscription response contains a reference to the
    # next page or not
    if 'nextPageToken' in subscriptions_response:
        next_page_token = subscriptions_response['nextPageToken']
    else:
        next_page_token = ''
    return next_page_token


def parse_youtube_subscriptions(subscriptions_response):
    channels = []

    # Add each result to the appropriate list
    for subscriptions_result in subscriptions_response.get("items", []):
        if subscriptions_result["snippet"]["resourceId"]["kind"] == "youtube#channel":
            channels.append("{} ({})".format(subscriptions_result["snippet"]["title"],
                                             subscriptions_result["snippet"]["resourceId"]["channelId"]))

    return channels


if __name__ == "__main__":
    # init
    all_channels = []

    print('Perform youtube subscriptions')
    # retrieve subscriptions
    all_channels = retrieve_youtube_subscriptions()
    print('Subscriptions complete')
    print('Subscriptions found: {}'.format(len(all_channels)))

    print("Channels:\n", "\n".join(all_channels), "\n")