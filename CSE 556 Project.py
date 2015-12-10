import copy, random, operator, math

maleUsersData = {}
femaleUsersData = {}
maleTotalScore = {}
femaleTotalScore = {}
maleRank = {}
femaleRank = {}

numOfUsers = 5

def calcRatingValue():
    interestV = 100
    interestRating = []

    for i in range(5):
        rnd = random.randrange(interestV)
        interestV = interestV - rnd
        interestRating.append(rnd)

    # Check to see if the sum of the interestRating = 100
    if sum(interestRating) < 100:
        interestRating[0] = interestRating[0] + 100 - sum(interestRating)

    interestRating = [x / 100.0 for x in interestRating]
 
    return interestRating

def calcPreferenceValue():
    preferenceV = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    preferenceRating = []

    for i in range(5):
        rnd = random.randrange(len(preferenceV))
        val = preferenceV.pop(rnd)
        preferenceRating.append(val)

    return preferenceRating

def populateSimulateUserData(name):
    data = {}
    for i in range(numOfUsers):
        rating = calcRatingValue()
        preference = calcPreferenceValue()
        userData = {"rating": rating, "preference": preference}
        userName = name + str(i + 1)
        data[userName] = userData

    return data

def calcUserTotalScore(firstData, secondData):
    userTotalScore = {}
    for key in firstData:
        totalScore = calcTotalScore(firstData.get(key), secondData)
        userTotalScore[key] = totalScore

    return userTotalScore

def calcTotalScore(firstData, secondData):
    interestRating = firstData["rating"]
    totalScores = {}

    for key in secondData:
        totalScore = 0
        for i, val in enumerate(secondData[key]["preference"]):
            totalScore = totalScore + (interestRating[i] * val)

        totalScores[key] = float("%.2f" % totalScore)

    return totalScores

def rankUser(totalScores):
    rank = copy.deepcopy(totalScores)
    for key in rank:
        totalScoreTuple = rank[key].items()
        rank[key] = bubbleSort(totalScoreTuple)

    return rank

def bubbleSort(arr):
    flag = True
    while flag:
        flag = False
        for i in range(len(arr)):
            if(i < len(arr) -1 and arr[i][1] < arr[i + 1][1]):
                tmp = arr[i]
                arr[i] = arr[i + 1]
                arr[i + 1] = tmp
                flag = True

    return arr

# To practice for interview, didn't really have to write a sorting algorithm
def mergeSort(arr):
    if len(arr) > 1:
        mid = len(arr) / 2
        leftArr = arr[:mid]
        rightArr = arr[mid:]

        mergeSort(leftArr)
        mergeSort(rightArr)

        i = 0
        j = 0
        k = 0

        while i < len(leftArr) and j < len(rightArr):
            if(leftArr[i] < rightArr[j]):
                arr[k] = leftArr[i]
                i = i + 1
            else:
                arr[k] = rightArr[j]
                j = j + 1
            k = k + 1

        while i < len(leftArr):
            arr[k] = leftArr[i]
            i = i + 1
            k = k + 1

        while j < len(rightArr):
            arr[k] = rightArr[j]
            j = j + 1
            k = k +1

    return arr


def matchmaker():
    maleFree = males[:]
    engaged  = {}
    maleRankCopy = copy.deepcopy(maleRank)
    femaleRankCopy = copy.deepcopy(femaleRank)
    while maleFree:
        male = maleFree.pop(0)
        maleList = maleRankCopy[male]
        female = maleList.pop(0)
        fiance = engaged.get(female[0])

        if not fiance:
            # She's free
            engaged[female[0]] = male
            print("  %s and %s" % (male, female))
        else:
            # The bounder proposes to an engaged lass!
            femaleList = femaleRankCopy[female[0]]
            if findIndex(femaleList, fiance) > findIndex(femaleList, male):
                # She prefers new guy
                engaged[female[0]] = male
                print("  %s dumped %s for %s" % (female, fiance, male))
                if maleRankCopy[fiance]:
                    # Ex has more girls to try
                    maleFree.append(fiance)
            else:
                # She is faithful to old fiance
                if maleList:
                    # Look again
                    maleFree.append(male)
    return engaged

def findIndex(userData, data):
    for i in range(len(userData)):
        if userData[i][0] == data:
            return i



# maleUsersData = populateSimulateUserData("Male ")
# femaleUsersData = populateSimulateUserData("Female ")
# print "Male: "
# print maleUsersData
# print "\nFemale: "
# print femaleUsersData
# print "\n"

maleUsersData = {'Male 1': {'rating': [0.46, 0.51, 0.0, 0.02, 0.01], 'preference': [9, 6, 8, 5, 3]}, 'Male 3': {'rating': [0.19, 0.74, 0.07, 0.0, 0.0], 'preference': [8, 9, 4, 2, 1]}, 'Male 2': {'rating': [0.72, 0.04, 0.04, 0.12, 0.08], 'preference': [5, 3, 9, 2, 7]}, 'Male 5': {'rating': [0.24, 0.43, 0.21, 0.1, 0.02], 'preference': [9, 2, 4, 7, 6]}, 'Male 4': {'rating': [0.37, 0.5, 0.02, 0.05, 0.06], 'preference': [9, 3, 4, 6, 5]}}
femaleUsersData = {'Female 1': {'rating': [0.97, 0.03, 0.0, 0.0, 0.0], 'preference': [3, 10, 2, 6, 5]}, 'Female 2': {'rating': [0.26, 0.69, 0.0, 0.05, 0.0], 'preference': [5, 6, 8, 7, 9]}, 'Female 3': {'rating': [0.17, 0.6, 0.18, 0.0, 0.05], 'preference': [1, 3, 6, 9, 4]}, 'Female 4': {'rating': [0.22, 0.15, 0.2, 0.36, 0.07], 'preference': [2, 3, 9, 5, 1]}, 'Female 5': {'rating': [1.0, 0.0, 0.0, 0.0, 0.0], 'preference': [6, 5, 7, 10, 3]}}

maleTotalScore = calcUserTotalScore(maleUsersData, femaleUsersData)
femaleTotalScore = calcUserTotalScore(femaleUsersData, maleUsersData)
# print "/n Male totalScore"
# print maleTotalScore
# print femaleTotalScore
# print ""
maleRank = rankUser(maleTotalScore)
femaleRank = rankUser(femaleTotalScore)
males = sorted(maleRank.keys())
females = sorted(femaleRank.keys())
# print maleRank
# print femaleRank
# print ""
print matchmaker()

# This is from http://rosettacode.org/wiki/Stable_marriage_problem#Python

# guyprefers = {
#  'abe':  ['abi', 'eve', 'cath', 'ivy', 'jan', 'dee', 'fay', 'bea', 'hope', 'gay'],
#  'bob':  ['cath', 'hope', 'abi', 'dee', 'eve', 'fay', 'bea', 'jan', 'ivy', 'gay'],
#  'col':  ['hope', 'eve', 'abi', 'dee', 'bea', 'fay', 'ivy', 'gay', 'cath', 'jan'],
#  'dan':  ['ivy', 'fay', 'dee', 'gay', 'hope', 'eve', 'jan', 'bea', 'cath', 'abi'],
#  'ed':   ['jan', 'dee', 'bea', 'cath', 'fay', 'eve', 'abi', 'ivy', 'hope', 'gay'],
#  'fred': ['bea', 'abi', 'dee', 'gay', 'eve', 'ivy', 'cath', 'jan', 'hope', 'fay'],
#  'gav':  ['gay', 'eve', 'ivy', 'bea', 'cath', 'abi', 'dee', 'hope', 'jan', 'fay'],
#  'hal':  ['abi', 'eve', 'hope', 'fay', 'ivy', 'cath', 'jan', 'bea', 'gay', 'dee'],
#  'ian':  ['hope', 'cath', 'dee', 'gay', 'bea', 'abi', 'fay', 'ivy', 'jan', 'eve'],
#  'jon':  ['abi', 'fay', 'jan', 'gay', 'eve', 'bea', 'dee', 'cath', 'ivy', 'hope']}
# galprefers = {
#  'abi':  ['bob', 'fred', 'jon', 'gav', 'ian', 'abe', 'dan', 'ed', 'col', 'hal'],
#  'bea':  ['bob', 'abe', 'col', 'fred', 'gav', 'dan', 'ian', 'ed', 'jon', 'hal'],
#  'cath': ['fred', 'bob', 'ed', 'gav', 'hal', 'col', 'ian', 'abe', 'dan', 'jon'],
#  'dee':  ['fred', 'jon', 'col', 'abe', 'ian', 'hal', 'gav', 'dan', 'bob', 'ed'],
#  'eve':  ['jon', 'hal', 'fred', 'dan', 'abe', 'gav', 'col', 'ed', 'ian', 'bob'],
#  'fay':  ['bob', 'abe', 'ed', 'ian', 'jon', 'dan', 'fred', 'gav', 'col', 'hal'],
#  'gay':  ['jon', 'gav', 'hal', 'fred', 'bob', 'abe', 'col', 'ed', 'dan', 'ian'],
#  'hope': ['gav', 'jon', 'bob', 'abe', 'ian', 'dan', 'hal', 'ed', 'col', 'fred'],
#  'ivy':  ['ian', 'col', 'hal', 'gav', 'fred', 'bob', 'abe', 'ed', 'jon', 'dan'],
#  'jan':  ['ed', 'hal', 'gav', 'abe', 'bob', 'jon', 'col', 'ian', 'fred', 'dan']}

# guys = sorted(guyprefers.keys())
# gals = sorted(galprefers.keys())


# def check(engaged):
#     inverseengaged = dict((v,k) for k,v in engaged.items())
#     for she, he in engaged.items():
#         shelikes = galprefers[she]
#         shelikesbetter = shelikes[:shelikes.index(he)]
#         helikes = guyprefers[he]
#         helikesbetter = helikes[:helikes.index(she)]
#         for guy in shelikesbetter:
#             guysgirl = inverseengaged[guy]
#             guylikes = guyprefers[guy]
#             if guylikes.index(guysgirl) > guylikes.index(she):
#                 print("%s and %s like each other better than "
#                       "their present partners: %s and %s, respectively"
#                       % (she, guy, he, guysgirl))
#                 return False
#         for gal in helikesbetter:
#             girlsguy = engaged[gal]
#             gallikes = galprefers[gal]
#             if gallikes.index(girlsguy) > gallikes.index(he):
#                 print("%s and %s like each other better than "
#                       "their present partners: %s and %s, respectively"
#                       % (he, gal, she, girlsguy))
#                 return False
#     return True

# def matchmaker():
#     guysfree = guys[:]
#     engaged  = {}
#     guyprefers2 = copy.deepcopy(guyprefers)
#     galprefers2 = copy.deepcopy(galprefers)
#     while guysfree:
#         guy = guysfree.pop(0)
#         guyslist = guyprefers2[guy]
#         gal = guyslist.pop(0)
#         fiance = engaged.get(gal)
#         if not fiance:
#             # She's free
#             engaged[gal] = guy
#             print("  %s and %s" % (guy, gal))
#         else:
#             # The bounder proposes to an engaged lass!
#             galslist = galprefers2[gal]
#             if galslist.index(fiance) > galslist.index(guy):
#                 # She prefers new guy
#                 engaged[gal] = guy
#                 print("  %s dumped %s for %s" % (gal, fiance, guy))
#                 if guyprefers2[fiance]:
#                     # Ex has more girls to try
#                     guysfree.append(fiance)
#             else:
#                 # She is faithful to old fiance
#                 if guyslist:
#                     # Look again
#                     guysfree.append(guy)
#     return engaged


# print('\nEngagements:')
# engaged = matchmaker()
