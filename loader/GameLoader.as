package loader {
	import chefhouse.*;
	import util.*;
	import user.*;
	import restaurant.*;
	public class GameLoader {
		private var indexInstant;
		private var userId:int = 1;
		public function GameLoader(indexInstant:index) {
			this.indexInstant = indexInstant;
			loadAll();
			trace('GameLoader');
			//loadUserInfo();
			//other actions only start loading after userInfo is loaded
			//loadUserIngre();
		}		
		
		private function loadAll():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'loadAll';
			var onResult:Function = loadAllSuccess;
			var onFault:Function = loadAllFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadAllSuccess(object:*) {
			trace('loadAllSuccess');
			//loadUserInfo();
			loadUserInfoSuccess(object.info);
			//loadUserFriend();
			loadUserFriendSuccess(object.friends);
			//loadUserItem();
			loadItemSuccess(object.items);
			//loadUserRecipe();
			loadUserRecipeSuccess(object.recipes);
			//loadUserBoom();
			loadUserBoomSuccess(object.booms);
			//loadUserQuest();
			loadUserQuestSuccess(object.quests);
			//loadUserBadges();
			loadUserBadgesSuccess(object.badges);
			//loadUserProgresses();
			loadUserProgressesSuccess(object.progresses);
			//loadUserWaiters();
			loadUserWaitersSuccess(object.waiters);
			//loadChallenges();
			loadChallengesSuccess(object.challenges);
			//loadMyChallenges();
			getMyChallengesSuccess(object.myChallenges);
//			loadChallengeResults();			
			getChallengeResultsSuccess(object.challengeResults);
			
			getSkillSuccess(object.skills);
			//do operation here
			
		}
		
		private function getSkillSuccess(object:*) {
			var userSkills:Array = GlobalVarContainer.getUser().getSkills();
			trace(userSkills, 'userSkillsBefore');
			for each (var skill:* in object) {
				userSkills[skill['SkillsUser']['skill_id'] - 1] = skill['SkillsUser']['level'];
/*				for each (var userSkill in userSkills) {
					if (userSkills.skillId === skill['SkillsUser']['skill_id']) {
						userSkill.level = skill['SkillsUser']['level'];
						break;
					}
				}*/
			}
			trace(userSkills, 'userSkillsAfter');
			indexInstant.setLoaded('skills', true);
			//push to user
		}
		
		private function loadAllFail(object:*) {
			trace('loadAllFail');
			for each (var random:* in object) {
				trace(random);
			}
		}
		
		
		
		private function loadMyChallenges():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getMyChallenges';
			var onResult:Function = getMyChallengesSuccess;
			var onFault:Function = getMyChallengesFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function getMyChallengesSuccess(object:*):void {
			trace('getMyChallengesSuccess');
			var gameUser:User = GlobalVarContainer.getUser();
			var challenges:Array = gameUser.getMyChallenges();
			
			for each (var challenge:* in object) {
				var tmpChallenge:Array = [int (challenge.Challenge.friend_id),int (challenge.Challenge.user_score), int (challenge.Challenge.friend_score),int (challenge.Challenge.start)];
				challenges.push(tmpChallenge);
				//to be run after friends are loaded
			}
			indexInstant.setLoaded('myChallenges', true);
		}
		
		private function getMyChallengesFail(object:*):void {
			trace('getMyChallengesFail');
			for each (var tmp:* in object) {
				trace(tmp);
			}
			loadMyChallenges();
		}
		
		private function loadChallengeResults():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getChallengeResults';
			var onResult:Function = getChallengeResultsSuccess;
			var onFault:Function = getChallengeResultsFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function getChallengeResultsSuccess(object:*):void {
			var gameUser:User = GlobalVarContainer.getUser();
			var challenges:Array = gameUser.getChallengeResults();
			
			for each (var challenge:* in object) {
/*				var friend:Friend = gameUser.findFriend(challenge.Challenge.user_id);
				friend.setChallenge([challenge.Challenge.friend_score, challenge.Challenge.user_score, challenge.Challenge.start]);*/
				var tmpChallenge:Array = [int (challenge.Challenge.friend_id), int (challenge.Challenge.user_score), int (challenge.Challenge.friend_score), int (challenge.Challenge.start)];
				challenges.push(tmpChallenge);
				//to be run after friends are loaded
			}
			trace('getChallengeResultsSuccess');
			indexInstant.setLoaded('challengeResults', true);
		}
		
		private function getChallengeResultsFail(object:*):void {
			trace('getChallengeResultsFail');
			for each (var tmp:* in object) {
				trace(tmp);
			}
			loadChallengeResults();
		}
		
		private function loadChallenges():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getChallenges';
			var onResult:Function = loadChallengesSuccess;
			var onFault:Function = loadChallengesFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadChallengesSuccess(object:*):void {
			var gameUser:User = GlobalVarContainer.getUser();
			var challenges:Array = gameUser.getChallenges();
						
			for each (var challenge:* in object) {
				var friend:Friend = gameUser.findFriend(challenge.Challenge.user_id);
				if (friend)
				{
					friend.setChallenge([int (challenge.Challenge.friend_score), int (challenge.Challenge.user_score), int (challenge.Challenge.start)]);
					var tmpChallenge:Array = [int (challenge.Challenge.user_id), int (challenge.Challenge.friend_score), int (challenge.Challenge.user_score), int (challenge.Challenge.start)];
					challenges.push(tmpChallenge);
					//to be run after friends are loaded
				}
			}
			trace('loadChallengesSuccess');
			indexInstant.setLoaded('challenges', true);
		}
		
		private function loadChallengesFail(object:*):void {
			for each (var tmp:* in object) {
				trace(tmp);
			}
			trace('loadChallengesFail');
			loadChallenges();
		}

		private function loadUserIngre():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getIngredients';
			var onResult:Function = loadUserIngreSuccess;
			var onFault:Function = loadUserIngreFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserIngreSuccess(object:*) {
			indexInstant.setLoaded('userRecipe', true);
			trace('loadUserIngreSuccess');
		}
		private function loadUserIngreFail(object:*) {
			trace('loadUserIngreFail');
			loadUserIngre();
		}
		private function loadUserQuest():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getQuestsProgress';
			var onResult:Function = loadUserQuestSuccess;
			var onFault:Function = loadUserQuestFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserQuestSuccess(object:*) {
			//this to make sure it loops through recipe one by one, thus easier
			object.sortOn('recipe_id', Array.NUMERIC);
			
			var questSetIds:Array = [];
			var questSets:Array = [];
			var questSet = {};
			var currentRecipeSet:Boolean = false;
			for each (var quest:* in object) {
				quest.current_number = int (quest.current_number);
				quest.recipe_id = int (quest.recipe_id);
				if (quest.recipe_id < 900 && !currentRecipeSet) {
					GlobalVarContainer.getUser().setCurrentRecipe(quest.recipe_id);
					currentRecipeSet = true;
				}
				if (questSet.id == null || questSet.id == undefined || questSet.id != quest.recipe_id) {
					questSet = {
						id: quest.recipe_id,
						firstVisit: 0, //hack for now
						quests: []
					}
					questSetIds.push(quest.recipe_id);
					questSets.push(questSet);
				}
				questSet.quests.push(quest);

				quest.pendingSave = 0;
			}
			
			for (var i:int = 0; i<questSets.length; ++i)
			{
				questSets[i].quests.sortOn('id', Array.NUMERIC);
			}
			GlobalVarContainer.getUser().setQuestSets(questSets);
			indexInstant.setLoaded('userQuest', true);
			trace('loadUserQuestSuccess');
		}
		
		private function sortOnId(a:*, b:*):Number
		{
			if (a.quest_id > b.quest_id)
			{
				return 1;
			}
			else if (a.quest_id < b.quest_id)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		private function loadUserQuestFail(object:*) {
			trace('loadUserQuestFail');
		}
		
		private function loadUserFriend():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getFriends';
			var onResult:Function = loadUserFriendSuccess;
			var onFault:Function = loadUserFriendFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserFriendSuccess(object:*) {
			var gameUser:User = GlobalVarContainer.getUser();
			for each (var tmp:* in object) {
				if (tmp.id != 1)
				{
					//matchmove
					var friend = new Friend(int (tmp.id), tmp.fb_id, int (tmp.exp), int (tmp.level), tmp.first_name, tmp.last_name, tmp.visited, int(tmp.stealCount), tmp.pic_square, tmp.mm_id, tmp.yahoo_id);
/*					var friend = new Friend(int (tmp.id), tmp.facebook_id, int (tmp.exp), int (tmp.level), tmp.first_name, tmp.last_name, tmp.visited, int(tmp.stealCount));*/
					gameUser.getFriends().push(friend);
				}
			}
			
			//matchmove
/*			gameUser.getFriends().push(new Friend(1, "99", 50000, 25, "Chef", "Toan", 1, 5));*/
			gameUser.getFriends().push(new Friend(1, "99", 50000, 25, "Chef", "Toan", 1, 5, 'http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs267.snc3/23089_4_2827_q.jpg', '0', '0'));
			
			
			//trace(gameUser.getFriends());
			trace('loadUserFriendSuccess');
			indexInstant.setLoaded('userFriend', true);
			//indexInstant.checkLoad();
			/*loadChallenges();
						loadMyChallenges();
						loadChallengeResults();*/
		}
		
		private function loadUserFriendFail(object:*) {
			for each (var tmp:* in object) {
				trace(tmp);
			}
			trace('loadUserFriendFail');
			loadUserFriend();
		}
		
		
		private function loadUserProgresses():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getProgresses';
			var onResult:Function = loadUserProgressesSuccess;
			var onFault:Function = loadUserProgressesFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserProgressesSuccess(object:*) {
			trace('loadUserProgressesSuccess');
			var gameUser:User = GlobalVarContainer.getUser();
			var progress:Object;
			progress = gameUser.getProgresses();
			progress.ninja = parseInt(object['1']);
			progress.time = parseInt(object['2']);
			progress.shop = parseInt(object['3']);
			progress.serve = parseInt(object['4']);	
			progress.vip = parseInt(object['5']);
			indexInstant.setLoaded('userProgress', true);
		}
		
		private function loadUserProgressesFail(object:*) {
			trace('loadUserProgressesFail');
			loadUserProgresses();
		}
		
		private function loadUserWaiters():void  {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getWaiters';
			//var onResult:Function = loadUserWaitersSuccess;
			var onFault:Function = loadUserWaitersFail;
			//HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserWaitersSuccess(object:*) {
			var totalWaiter:int = 0;
			var gameUser = GlobalVarContainer.getUser();
			for each (var waiter:* in object) {
				++totalWaiter;
				gameUser.setWaiterType(int (waiter.waiter_type));
				gameUser.setWaiterDuration(int (waiter.total));
				gameUser.setWaiterRemain(int (waiter.remain));
			}
			gameUser.setWaiterQuantity(totalWaiter);
			trace('loadUserWaitersSuccess');
			indexInstant.setLoaded('userWaiters', true);
		}
		
		private function loadUserWaitersFail(object:*) {
			trace('loadUserWaitersFail');
			loadUserWaiters();
		}
		
		private function loadUserBadges():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getBadges';
			var onResult:Function = loadUserBadgesSuccess;
			var onFault:Function = loadUserBadgesFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserBadgesSuccess(object:*) {
			trace('loadUserBadgesSuccess');
			var gameUser:User = GlobalVarContainer.getUser();
			var tmpArray:Array = [];
			for each (var item:* in object) {
				tmpArray.push(item);
			}
			gameUser.setBadges(tmpArray);
			indexInstant.setLoaded('userBadge', true);
		}
		
		private function loadUserBadgesFail(object:*) {
			trace('loadUserBadgesFail');
			loadUserBadges();
		}
		
		private function loadUserInfo():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getInfo';
			var onResult:Function = loadUserInfoSuccess;
			var onFault:Function = loadUserInfoFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserInfoSuccess(object:*) {
			var gameUser:User = GlobalVarContainer.getUser();
			if (object.last_learn_recipe !== null && object.last_learn_recipe != 0 && object.last_learn_recipe < 900) {
				//trace(object.last_learn_recipe, 'recipe');
				gameUser.setJustLearnedRecipe(true);
				gameUser.setCurrentRecipe(object.last_learn_recipe);
			}
			gameUser.setId(int (object.id));
			gameUser.setFacebookId(object.facebook_id);
			gameUser.setEnergy(int (object.energy));
			gameUser.setMoney(object.money);
			gameUser.setExp(int (object.exp));
			gameUser.setLevel(int (object.level));
			gameUser.setCash(int (object.cash));
			gameUser.setFirstBoom(int (object.variables.firstBoom));
			gameUser.setNextRecover(int (object.next_recover));
			gameUser.setLastName(object.last_name);
			gameUser.setFirstName(object.first_name);
			gameUser.setFirstVisit(object.variables.first_visit);
			gameUser.setChef1(object.variables.chef1);
			gameUser.setTutProgress(object.variables.tutProgress);
			gameUser.setChef2(object.variables.chef2);
			gameUser.setChef3(object.variables.chef3);
			gameUser.setVipBJ(object.variables.vipBJ);
			gameUser.setLightHouse(object.variables.lighthouse);
			gameUser.setNinjaBJ(object.variables.ninjaBJ);
			gameUser.setNinjaRes(object.variables.ninjaRes);
			gameUser.setFirstBJ(object.variables.firstBJ);
			gameUser.setCaptureVSComp(object.variables.setCaptureVSComp);
			gameUser.setSession(object.session);
			trace(object.skillPoints);
			gameUser.setSkillPoints(object.skillPoints);
			gameUser.setPhotoURL(object.pic_square);
			gameUser.setAwayEarning(object.away);
			indexInstant.setLoaded('userInfo', true);
			
			//load others
			/*loadUserFriend();
						loadUserItem();
						loadUserRecipe();
						loadUserBoom();
						loadUserQuest();
						loadUserBadges();
						loadUserProgresses();
						loadUserWaiters();*/
			//indexInstant.checkLoad();
			trace('userInfoSuccess');
		}
		
		private function loadUserInfoFail(object:*) {
			for each (var obje:* in object) {
				trace(obje);
			}
			trace('userInfoFail');
			loadUserInfo();//keep loading again
		}
		
		private function loadUserItem() {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getItems';
			var onResult:Function = loadItemSuccess;
			var onFault:Function = loadItemFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadItemSuccess(object:*):void {
			var gameUser = indexInstant.getUser();
			var energyPack = 0;
			for each (var item:* in object) {
				gameUser.getItems().push(item);
				
				if (item.type == 9 && item.type_id == 1)
				{
					energyPack++;
				}
				gameUser.setEnergyPack(energyPack);
			}
			trace('loadUserItemSuccess');
			indexInstant.setLoaded('userItem', true);
			//indexInstant.checkLoad();
		}
		
		private function loadItemFail(object:*):void {
			for each (var error:* in object) {
				trace(error);
			}
			trace('loadUserItemFail');
			this.loadUserItem();
		}
		
		private function loadUserRecipe():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getRecipes';
			var onResult:Function = loadUserRecipeSuccess;
			var onFault:Function = loadUserRecipeFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserRecipeSuccess(object:*):void {
			
			trace('loadUserRecipeSuccess');
			for each  (var tmpRecipe:* in object) {
				var recipe:Object = {
					id: int (tmpRecipe.RecipesUser.recipe_id),
					rating: int (tmpRecipe.RecipesUser.rating),
					quantity: int (tmpRecipe.RecipesUser.quantity),
					owned: int (tmpRecipe.RecipesUser.owned)
				};
				GlobalVarContainer.getUser().getRecipes().push(recipe);
			}
			
			GlobalVarContainer.getUser().getRecipes().sortOn('id', Array.NUMERIC);
/*			CookPrepare.setRecipeListArray(recipeList);
			CookPrepare.setRecipeRatingArray(recipeRating);*/
			indexInstant.setLoaded('userRecipe', true);
			//indexInstant.checkLoad();
		}
		private function loadUserRecipeFail(object:*):void {
			trace('loadUserRecipeFail');
			loadUserRecipe();
		}
		
		private function loadUserBoom():void {
			var remoteClass:String = 'UsersController';
			var remoteMethod:String = 'getBooms';
			var onResult:Function = loadUserBoomSuccess;
			var onFault:Function = loadUserBoomFail;
			HttpLoader.load(remoteClass, remoteMethod, onResult, onFault);
		}
		
		private function loadUserBoomSuccess(object:*):void {
			
			trace('loadUserBoomSuccess');
			var boomQuantity:Array = new Array();
			var boomList:Array = new Array();
			for each (var tmpBoom:* in object) {
				var boom:Object = {
					id: int (0 - tmpBoom.BoomsUser.boom_id),
					quantity: int (tmpBoom.BoomsUser.quantity)
				}
				GlobalVarContainer.getUser().getBooms().push(boom);
			}
			indexInstant.setLoaded('userBoom', true);
		}
		
		private function loadUserBoomFail(object:*):void {
			trace('loadUserBoomFail');
			loadUserBoom();
		}
	}
}