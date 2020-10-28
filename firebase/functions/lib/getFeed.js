"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
//import * as functions from 'firebase-functions';
const admin = require("firebase-admin");
exports.getFeedModule = function (req, res) {
    function compileFeedPost() {
        return __awaiter(this, void 0, void 0, function* () {
            const listOfPosts = yield getAllPosts(res);
            res.send(listOfPosts);
        });
    }
    compileFeedPost().then().catch();
};
/*

export const getFeedModule = function(req, res) {
    const uid = String(req.query.uid);

    async function compileFeedPost() {
      const following = await getFollowing(uid, res) as any;

      let listOfPosts = await getAllPosts(following, uid, res);

      listOfPosts = [].concat.apply([], listOfPosts); // flattens list

      res.send(listOfPosts);
    }

    compileFeedPost().then().catch();
}

async function getAllPosts(following, uid, res) {
    const listOfPosts = [];

    for (const user in following){
        listOfPosts.push( await getUserPosts(following[user], res));
    }

    // add the current user's posts to the feed so that your own posts appear in your feed
    listOfPosts.push( await getUserPosts(uid, res));

    return listOfPosts;
}

function getUserPosts(userId, res){
    const posts = admin.firestore().collection("posts")
.where("ownerId", "==", userId)
.orderBy("timestamp")

    return posts.get()
    .then(function(querySnapshot) {
        const listOfPosts = [];

        querySnapshot.forEach(function(doc) {
            listOfPosts.push(doc.data());
        });

        return listOfPosts;
    })
}


function getFollowing(uid, res){
    const doc = admin.firestore().doc(`users/${uid}`)
    return doc.get().then(snapshot => {
      const followings = snapshot.data().following;

      const following_list = [];

      for (const following in followings) {
        if (followings[following] === true){
          following_list.push(following);
        }
      }
      return following_list;
  }).catch(error => {
      res.status(500).send(error)
    })
}
*/
function getAllPosts(res) {
    const posts = admin.firestore().collection("posts")
        .orderBy("timestamp");
    return posts.get()
        .then(function (querySnapshot) {
        const listOfPosts = [];
        querySnapshot.forEach(function (doc) {
            listOfPosts.push(doc.data());
        });
        return listOfPosts;
    });
}
//# sourceMappingURL=getFeed.js.map