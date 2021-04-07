# -*- coding: utf-8 -*-

import json, urllib

key = ''
locales = ["es", "ru", "uk"]

def createGenresList(mediaType):
    baseUrl = "https://api.themoviedb.org/3/genre/" + mediaType + "/list?api_key=" + key + "&language="

    jsonurl = urllib.urlopen(baseUrl + "en")
    baseGenresResult = json.loads(jsonurl.read())['genres']

    baseGenres = { }

    for genre in baseGenresResult:
        baseGenres[genre["id"]] = { "name": genre["name"], "localizedNames": { } }

    for locale in locales:
        jsonurl = urllib.urlopen(baseUrl + locale)
        genres = json.loads(jsonurl.read())['genres']

        for genre in genres:
            id = genre["id"]
            baseGenre = baseGenres[id]
            localizedName = genre["name"]
            baseGenre["localizedNames"][locale] = localizedName

    result = []
    for genre in baseGenres:
        result.append({ "path": "discover/" + mediaType,
                        "mediaType": mediaType,
                        "query": "with_genres=" + str(genre) + "&sort_by=vote_count.desc",
                        "name": baseGenres[genre]["name"],
                        "localizedNames": baseGenres[genre]["localizedNames"],
                        })

    print json.dumps(result, ensure_ascii=False).encode('utf8')

createGenresList("movie")
createGenresList("tv")