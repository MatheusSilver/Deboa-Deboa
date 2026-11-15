package gamejolt;

import gamejolt.InviteBackEnd.InviteObject;
import flixel.FlxG;
import haxe.Http;
import haxe.Json;
import haxe.crypto.Md5;
import haxe.crypto.Sha1;
import com.akifox.asynchttp.*;
import flixel.util.FlxTimer;

/**
 * A completely original GameJolt Client made by GamerPablito, using Haxe Crypto Encripting and Http tools
 * to gather info about the GameJolt API with ease.
 * 
 * Originally made for the game Friday Night Funkin', but it can also be used for every game made with HaxeFlixel.
 * 
 * No extra extensions required (except the basic Flixel and Haxe ones).
 */
class GJClient
{
    static var printPrefix:String = "GameJolt Client:";

    /*
        ----------------------------------------------------------------
        -------------> GUI = GameJolt User Information <------------------
        --> EVERY COMMAND HERE WILL WORK ONLY IF GUI PARAMETERS EXIST!! <--
        ----------------------------------------------------------------
    */

    /**
     * Tells you if some GUI already exists in the game app or not.
     * @return Is it available?
     */
    public static function hasLoginInfo():Bool {return getUser() != null && getToken() != null;}

    /**
     * Tells you if the GameJolt info about your game is available or not.
     * @return Is it available?
     */
    public static function hasGameInfo():Bool {return GJKeys.id != 0 && GJKeys.key != '';}

    /**
     * It tells you if you're actually logged in or not (Read Only, don't change it!).
     */
    public static var logged:Bool = false; // Logged in or not

    /**
     * If `true`, the functions will use `Md5` encriptation for data processing; if `false`, they'll use `Sha1` encriptation instead.
     */
    public static var useMd5:Bool = true;
    public static var shitt:Bool=false;

    /**
     * Sets a new GUI in the database, the Username and the Game Token of the player respectively.
     * This command also closes the previous session (if there was one active) before replace the actual GUI.
     * 
     * If you leave the parameters with an empty string or null, you will be logged out successfully,
     * and you will be able to log in again with other user's GUI.
     * 
     * But if you just wanna log out without erase your GUI from the application, use `logout()` instead.
     * 
     * @param user The Username of the Player.
     * @param token The Game Token of the Player.
     */
    public static var userName:String;
    public static var avatarURL:String;
    public static var myID:String;
    public static function setUserInfo(user:Null<String>, token:Null<String>)
    {

        var temp_user = getUser();
        var temp_token = getToken();
        if (user == '') user = null;
        if (token == '') token = null;

        logout();

        FlxG.save.data.user = user;
        FlxG.save.data.token = token;

        if (hasLoginInfo())
        {
            authUser(
                function () {printMsg('GUI Parameters Changed: New User -> ${getUser()} | New Token -> ${getToken()}'); if(shitt){GameJoltLoginState.IrParaMenu(); shitt=false;}; userName = user;},
                function ()
                {
                    FlxG.save.data.user = user;
                    FlxG.save.data.token = token;
                }
            );
                //login();
            //initialize();
        }
    }

    /**
     * Run this command to make sure if the actual GUI inserted about a user really exists in GameJolt.
     * 
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     */
    public static function authUser(?onSuccess:() -> Void, ?onFail:() -> Void)
    {
        var urlData = urlResult(urlConstruct('users', 'auth'),
        function () {printMsg('User authenticated successfully!'); userName = FlxG.save.data.user; if (onSuccess != null) onSuccess();},
        function ()
        {
            printMsg('User authentication failed!');
            if(shitt){GameJoltLoginState.Desesconder();}
            setUserInfo(null, null);
            noDataWarned = false;
            if (onFail != null) onFail();
        });
        if (urlData != null) urlData; else return;
    }

    /**
     * This function fetches the information of any user in GameJolt, according to the ID inserted.
     * 
     * @see The `formats` folder, to get more info about how formats are setted like.
     * 
     * @param id The ID of the user to fetch the info from (leave `null` if you wanna fetch the info from the actual user logged in).
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     * @return The Data fetched form the user (or `null` if that info doesn't exist)
     */
    public static function getUserData(?id:Int, ?onSuccess:() -> Void, ?onFail:() -> Void, ?async:Bool, ?inviteObject:InviteObject):Null<User>
    {
        var daUser:Null<String> = null;
        var daFormat:Null<User> = null;

        var daParam:Null<Array<Array<String>>> = id != null ? [['user_id', Std.string(id)]] : null;
        var urlData = urlResult(urlConstruct('users', null, daParam, id == null, false), onSuccess, onFail, async, null, USER, inviteObject);

        if (urlData != null)
        {
            if (urlData.users[0] != null)
            {
                daUser = urlData.users[0].developer_name;
                daFormat = cast urlData.users[0];
                if(!async){printMsg('$daUser\'s data fetched sucessfully!');}
            }
            else
            {
                if(!async){printMsg('Data fetching of the user $id failed!');}
                if (onFail != null) onFail();
            }
        }
        else
        {
            if(!async){printMsg('Data fetching of the user $id failed!');}
            if (onFail != null) onFail();
        }

        return daFormat;
    }

    /**
     * Throws the friend list of the user that's actually logged in.
     * 
     * Not only that, it will throw the individual info of every friend that's fetched here!
     * 
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     * @return The long list of every friend's data.
     */
    public static function getFriendsList(?onSuccess:() -> Void, ?onFail:() -> Void):Null<Array<User>>
    {
        var urlData = urlResult(urlConstruct('friends'), null, onFail);
        var friendList:Array<User> = [];
        var fetchedFriends:Null<Array<Dynamic>> = null;

        if (urlData != null) fetchedFriends = urlData.friends;

        if (fetchedFriends != null && logged)
        {
            for (person in fetchedFriends)
            {
                var daID:Int = person.friend_id;
                var daFriend:Null<User> = getUserData(daID);
                
                if (daFriend != null)
                {
                    friendList.push(daFriend);
                    printMsg('Fetched Friend: ${daFriend.developer_name} (@${daFriend.username})');
                }
                else printMsg('Failed to fetch friend (ID: ${daID})');
            }

            printMsg('Friends list fetched correctly!');
            if (onSuccess != null) onSuccess();
            return friendList;
        }
        else
        {
            printMsg('Friends list fetching failed!');
            if (onFail != null) onFail();
        }

        return [];
    }

    /**
     * Fetches all the trophies available in your game,
     * all the trophies will have their own data formatted in .json.
     * 
     * It also tells you if you've already achieved them or not. Very useful if you're making a trophie screen or smth related.
     * 
     * @see The `formats` folder, to get more info about how formats are setted like.
     * 
     * @param achievedOnes  Whether you want the list to be only with achieved trophies or unachived trophies.
     *                        Leave blank if you want to see all the trophies no matter if they're achieved or not.
     *                        If your game doesn't have any trophies in its GameJolt page,
     *                        or doesn't appear according to what you choose in this variable, the result will be `null`.
     * @param onSuccess     Put a function with actions here, they'll be processed if the process finish successfully.
     * @param onFail         Put a function with actions here, they'll be processed if an error has ocurred during the process.
     * @return The array with all the Trophies of the game in .json format
     *          (returns `null` if there are no Trophies in the game to fetch or if there's no GUI inserted in the application yet).
     */
    public static function getTrophiesList(?achievedOnes:Bool, ?onSuccess:() -> Void, ?onFail:() -> Void, ?async:Bool = false, ?customCallback:(?result:Null<Dynamic>) -> Void):Null<Array<Trophie>>
    {
        var daParam:Null<Array<Array<String>>> = achievedOnes != null ? [['achieved', Std.string(achievedOnes)]] : null;
        var urlData = urlResult(urlConstruct('trophies', null, daParam),
        function () {printMsg('Trophies list fetched successfully!'); if (onSuccess != null) onSuccess();},
        function () {printMsg('Trophies list fetching failed!'); if (onFail != null) onFail();}, true, customCallback, null, null, true);
        var daFormat:Null<Array<Trophie>> = urlData != null && logged ? urlData.trophies : [];
        return daFormat;
    }

    static var daAddList:Array<Trophie>;
    /**
     * Gives a trophie from the game to the actual user logged in!
     * 
     * Won't do anything if you're not logged so don't worry, the game won't crash.
     * 
     * @param id The ID of the trophie to achieve.
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     *                    It will also contain the achieved trophie data in order to be used for other creative purposes.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     */
    public static function trophieAdd(id:Int, ?onSuccess:Trophie -> Void, ?onFail:() -> Void)
    {
        daAddList = [];
        getTrophiesList(false, function(){
            if (logged && daAddList != null)
                {
                    var urlData = urlResult(urlConstruct('trophies', 'add-achieved', [['trophy_id', Std.string(id)]]),
                    function ()
                    {
                        for (troph in daAddList)
                        {
                            if (troph.id == id)
                            {
                                if (troph.achieved == false)
                                {
                                    printMsg('Trophie "${troph.title}" has been achieved by ${getUser()}!');
                                    if (onSuccess != null) onSuccess(troph);
                                }
                                else printMsg('Trophie "${troph.title}" is already taken by ${getUser()}!');
                                break;
                            }
                        }
                    },
                    function ()
                    {
                        printMsg('The trophie ID "$id" was not found in the game database!');
                        if (onFail != null) onFail();
                    }, true);
                    if (urlData != null) urlData; else return;   
                }
        }, null, true, function(?result:Null<Dynamic>){
            if(result.trophies == null)
                return;
            daAddList = result.trophies;
        });

        
    }

    static var daRemoveList:Array<Trophie>;
    /**
     * Removes a trophie of the game from the actual user logged in. Useful in case it was achieved by cheating or just for test it out!
     * 
     * Won't do anything if you're not logged so don't worry, the game won't crash.
     * 
     * @param id The ID of the trophie to remove.
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     *                    It will also contain the removed trophie data in order to be used for other creative purposes.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     */
    public static function trophieRemove(id:Int, ?onSuccess:Trophie -> Void, ?onFail:() -> Void)
    {
        daRemoveList = [];
        getTrophiesList(function(){
            if (logged && daRemoveList != null)
                {
                    var urlData = urlResult(urlConstruct('trophies', 'remove-achieved', [['trophy_id', Std.string(id)]]),
                    function ()
                    {
                        for (troph in daRemoveList)
                        {
                            if (troph.id == id)
                            {
                                if (troph.achieved != false)
                                {
                                    printMsg('Trophie "${troph.title}" has been quitted from ${getUser()}!');
                                    if (onSuccess != null) onSuccess(troph);
                                }
                                else printMsg('Trophie "${troph.title}" is not taken by ${getUser()} yet!');
                                break;
                            }
                        }
                    },
                    function ()
                    {
                        printMsg('The trophie ID "$id" was not found in the game database!');
                        if (onFail != null) onFail();
                    }, true);
                    if (urlData != null) urlData; else return;  
                }
        }, null, true, function(?result:Null<Dynamic>){
            if(result.trophies == null)
                return;
            daRemoveList = result.trophies;
        });


    }

    /**
     * Fetches all the scores submitted on a score table in your game,
     * all the scores will have their own data formatted in .json.
     * 
     * You can set if you want to fetch the scores in the table from the actual user or from the game in general!
     * 
     * @see The `formats` folder, to get more info about how formats are setted like.
     * 
     * @param fromUser This is where you can set if you want to fetch scores from the actual logged user only (`true`), or from the game itself (`false`)
     * @param table_id The score Table ID where the scores will be fetched from (if `null`, the scores will be fetched from the "Primary" score table in your game)
     * @param delimiter If you want to fetch the scores that are major or minor than a certain value, set it here, otherwise leave in blank.
     *                    (Note: If you want the scores that are ABOVE the value, set it in POSITIVE, but
     *                     if you want the scores that are BELOW the value, set it in NEGATIVE)
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     * @param limit The number of scores to return. Must be a number between 1 and 100 (Default: 10)
     * @return The array with all the Scores of the game in .json format from the settled score Table ID
     *          (return `null` if there are no Scores in the game to fetch or if there's no GUI inserted in the application yet).
     */
    public static function getScoresList(fromUser:Bool, ?table_id:Int, ?delimiter:Int, ?onSuccess:() -> Void, ?onFail:() -> Void, limit:Int = 10):Null<Array<Score>>
    {
        var daParams:Array<Array<String>> = [];

        if (table_id != null) daParams.push(['table_id', Std.string(table_id)]);
        if (delimiter != null) daParams.push([delimiter >= 0 ? 'better_than' : 'worse_than', Std.string(Math.abs(delimiter))]);

        if (limit <= 0) limit = 1;
        if (limit > 100) limit = 100;

        if (limit != 10) daParams.push(['limit', Std.string(limit)]);

        var urlData = urlResult(urlConstruct('scores', null, daParams != [] ? daParams : null, fromUser, fromUser),
        function ()
        {
            printMsg('Scores list from the ${table_id == null ? 'Principal Score Table' : 'Table ID:' + Std.string(table_id)} fetched successfully!');
            if (onSuccess != null) onSuccess();
        },
        function ()
        {
            printMsg('Scores list from the ${table_id == null ? 'Principal Score Table' : 'Table ID:' + Std.string(table_id)} fetching failed');
            if (onFail != null) onFail();
        });
        var daFormat:Null<Array<Score>> = urlData != null && logged ? urlData.scores : null;
        return daFormat;
    }

    /**
     * Submits a new score made by the actual logged user to a specified score table in your game!
     * 
     * @param score_content The stringified version of the score. Example: 500 jumps.
     * @param score_value The score itself. Example: 500.
     * @param extraInfo If you want to, you can give extra information about how the score was obtained,
     *                    useful to make game developers know if the player obtained that score legally, but this is completely optional.
     * @param table_id The score table ID where the new score will be submitted to (if `null`, the score will be submitted from the "Primary" score table in your game).
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     *                    It will also contain the submitted score data in order to be used for other creative purposes.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     */
    public static function submitNewScore(score_content:String, score_value:Int, ?extraInfo:String, ?table_id:Int, ?onSuccess:Score -> Void, ?onFail:() -> Void)
    {
        var daParams:Array<Array<String>> = [
            ['score', score_content],
            ['sort', Std.string(score_value)]
        ];

        if (extraInfo != null) daParams.push(['extra_data', extraInfo]);
        if (table_id != null) daParams.push(['table_id', Std.string(table_id)]);

        if (logged)
        {
            var urlData = urlResult(urlConstruct('scores', 'add', daParams),
            function ()
            {
                if (logged)
                {
                    var daScore:Score =
                    {
                        score: score_content,
                        sort: score_value,
                        extra_data: extraInfo != null ? extraInfo : '',
                    };

                    printMsg('Score submitted successfully!');
                    if (onSuccess != null) onSuccess(daScore);
                }
            },
            function ()
            {
                printMsg('Score submitting failed!');
                if (onFail != null) onFail();
            });
            if (urlData != null) urlData; else return;   
        }
    }

    public static function setData(txtContent:String, dataKey:String, ?onSuccess:DataStore -> Void, ?onFail:() -> Void, ?isPublic:Bool = false, ?async:Bool = false) // GJClient.setData("valor", "key"); exemplo de aplicar algum valor
        {

            var daParams:Array<Array<String>> = isPublic ? [
                ['game_id', Std.string(GJKeys.id)],
                ['key', dataKey],
                ['data', txtContent],
            ] : [
                ['game_id', Std.string(GJKeys.id)],
                ['key', dataKey],
                ['data', txtContent],
                ['username', GJClient.userName],
                ['user_token', getToken()]
            ];
    
            if (logged)
            {
                var urlData = urlResult(urlConstruct('data-store', 'set', daParams, !isPublic, !isPublic),
                function ()
                {
                    if (logged)
                    {
                        var daData:DataStore = isPublic ?{
                            game_id: Std.string(GJKeys.id),
                            key: dataKey,
                            data: txtContent
                        } :
                        {
                            game_id: Std.string(GJKeys.id),
                            key: dataKey,
                            data: txtContent,
                            username: GJClient.userName,
                            user_token: getToken()
                        };
                        if(!async) {printMsg('Data setted successfully!');}
                        if (onSuccess != null) onSuccess(daData);
                    }
                },
                function ()
                {
                    if(!async)
                    {
                        printMsg('Data setting failed!');
                    }
                    if (onFail != null) onFail();
                }, async, null, INVITE, null, false);
                if (urlData != null) urlData; else return;   
            }
        }
    
        public static function getData(dataKey:String, ?onSuccess:() -> Void, ?onFail:() -> Void, ?isPublic:Bool = false, ?async:Bool = false, ?customCallback:(?result:Null<Dynamic>) -> Void, ?invites:Bool):String // GJClient.getData("key"); exemplo de puxar algum valor
            {
                var daParams:Array<Array<String>> = isPublic ? [
                    ['game_id', Std.string(GJKeys.id)],
                    ['key', dataKey]
                ]: [
                    ['game_id', Std.string(GJKeys.id)],
                    ['key', dataKey],
                    ['username', GJClient.userName],
                    ['user_token', getToken()]
                ];

                var urlData = urlResult(urlConstruct('data-store', null, daParams, !isPublic, !isPublic),
                function () {if(async) return; printMsg('Data fetched successfully!'); if (onSuccess != null) onSuccess();},
                function () {if(async) return; printMsg('Data fetching failed!'); if (onFail != null) onFail();}, async, customCallback, invites ? INVITE : USER);
                var daData:Null<DataStore> = urlData != null && logged ? urlData : null;
                var valuetoReturn:String;
                if(daData != null)
                    {
                        valuetoReturn = daData.data;
                    }
                else
                    {
                        valuetoReturn = null;
                    }
                return valuetoReturn;
            }

            public static function removeData(dataKey:String, ?onSuccess:() -> Void, ?onFail:() -> Void) // GJClient.removeData("key"); exemplo de deletar algum valor
                {
                    var daParams:Array<Array<String>> = [
                        ['game_id', Std.string(GJKeys.id)],
                        ['key', dataKey],
                        ['username', GJClient.userName],
                        ['user_token', getToken()]
                    ];
                    if(getData(dataKey)!=null)
                        {
                            var urlData = urlResult(urlConstruct('data-store', 'remove', daParams),
                            function () {printMsg('Data removed successfully!'); if (onSuccess != null) onSuccess();},
                            function () {printMsg('Data remove failed!'); if (onFail != null) onFail();});
                        }
                    else
                        {
                            printMsg('Could not found Data to remove!');
                        }
                }
        

    /**
     * Gives you the global rank you got in a certain score table in your game.
     * This is given according to the top score you have in that table.
     * 
     * @param table_id The score sable ID where the rank will be obtained from (if `null`, the rank will be given from the "Primary" score table in your game).
     * @return The global rank obtained from the score table (It returns -1 if the process was failed).
     */
    public static function getGlobalRank(?table_id:Int):Int
    {
        var daTempScore = getScoresList(true, table_id, null, null, null, 1);

        if (logged && daTempScore != null)
        {
            var daParams = [['sort', Std.string(daTempScore[0].sort)]];
            if (table_id != null) daParams.push(['table_id', Std.string(table_id)]);

            var urlData = urlResult(urlConstruct('scores', 'get-rank', daParams, false, false));
            var daRank:Int = urlData != null && logged ? urlData.rank : -1;

            return daRank;
        }

        return -1;
    }

    /**
     * This will open your GameJolt session.
     * 
     * Useful for re-open a session when a new GUI is setted by `setUserInfo()`,
     * or if you closed your session by decision of yours (without erasing your GUI, using `logout()`, otherwise re-use `setUserInfo()`).
     * 
     * (Do not compare with the `initialize()` function).
     * 
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     *                    It will also contain the new data fetched from the new logged user for other creative purposes.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     */
    public static function login(?onSuccess:User -> Void, ?onFail:() -> Void)
    {
        var urlData = urlResult(urlConstruct('sessions', 'open'),
        function ()
        {
            var userData = getUserData();
            avatarURL = userData.avatar_url;
            myID = Std.string(userData.id);
            if (!logged) {printMsg('Logged Successfully! Welcome back ${getUser()}!');}
            if (onSuccess != null && !logged && userData != null) onSuccess(userData);
            logged = true;
            updateStatus(true);
        },
        function ()
        {
            printMsg('Login process failed!');
            GameJoltLoginState.Desesconder();
            if (onFail != null) onFail();
        });
        if (urlData != null && !logged) urlData; else return;
    }

    /**
     * If there's a session active, this command will log it out. Pretty self-explanatory isn't it?
     * 
     * But, if you want to log out, but also want to erase your data from the application,
     * you can use the function `setUserInfo()` with null or empty parameters.
     * 
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process. 
     */
    public static function logout(?onSuccess:() -> Void, ?onFail:() -> Void)
    {
        var urlData = urlResult(urlConstruct('sessions', 'close'),
        function ()
        {
            if (logged) printMsg('Logged out successfully!');
            if (onSuccess != null && logged) onSuccess();
            updateStatus(false);
            logged = false;
        },
        function ()
        {
            printMsg('Logout process failed!');
            if (onFail != null) onFail();
        });
        if (logged && urlData != null) urlData; else return;
    }

    /**
     * If there's a session active, this function keeps the session active, so it needs to be placed in somewhere it can be executed repeatedly.
     * 
     * @param onPing Put a function with actions here, they'll be processed every time a ping is made successfully.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.  
     */
    public static function pingSession(?onPing:() -> Void, ?onFail:() -> Void)
    {
        if (logged)
        {
            var urlData = urlResult(urlConstruct('sessions', 'ping'),
            function ()
            {
                printMsg('Session pinged!');
                if (onPing != null) onPing();
            },
            function ()
            {
                printMsg('Ping failed! You\'ve been disconnected!');
                if (onFail != null) onFail();
                logged = false;
            });
            if (urlData != null) urlData;
        }
    }

    /**
     * This initialize the client in general.
     * It opens your session and sync your data according to the saved GUI data for a better experience when the user comes back.
     * 
     * (Do not compare with the `login()` function)
     * 
     * @param onSuccess Put a function with actions here, they'll be processed if the process finish successfully. It will also contain the new data fetched from the new logged user.
     *                    It will also contain the user data obtained in order to be used for other creative purposes.
     * @param onFail Put a function with actions here, they'll be processed if an error has ocurred during the process.
     */
    public static function initialize(?onSuccess:User -> Void, ?onFail:() -> Void)
    {
        if (hasLoginInfo() && !logged)
        {
            authUser(function () {login(function (userData:User) {if (onSuccess != null && !logged) onSuccess(userData);},onFail);}, onFail);
            if (logged){ printMsg('Initialized successfully!'); var userData = getUserData();    avatarURL = userData.avatar_url;}
        }
        else {printMsg('Initializing failed!'); if(shitt){GameJoltLoginState.Desesconder();}}
    }

    // INTERNAL FUNCTIONS (DON'T ALTER IF YOU DON'T KNOW WHAT YOU'RE DOING!!)

    static var noDataWarned:Bool = false;

    static function printMsg(message:String) {Sys.println('$printPrefix $message');}

    static function urlConstruct(command:String, ?action:String, ?params:Array<Array<String>>, userAllowed:Bool = true, tokenAllowed:Bool = true):Null<Http>
    {
        if (hasLoginInfo() && hasGameInfo())
        {
            var mainURL:String = "http://api.gamejolt.com/api/game/v1_2/";

            mainURL += command;
            mainURL += '/' + (action != null ? '$action/' : '') + '?';    
            mainURL += 'game_id=${Std.string(GJKeys.id)}'; // Private Thingie (Fuck you hackers lmao)

            if (userAllowed) mainURL += '&username=${getUser()}';
            if (tokenAllowed) mainURL += '&user_token=${getToken()}';
    
            if (params != null) {for (pars in params) mainURL += '&${pars[0]}=${pars[1]}';}

            var daEncode:String = mainURL + GJKeys.key; // Private thingie (Fuck you hackers lmao)
    
            mainURL += '&signature=${useMd5 ? Md5.encode(daEncode) : Sha1.encode(daEncode)}';
            //trace(mainURL); :skull:
            return new Http(mainURL);
        }

        if (!hasGameInfo() && !noDataWarned) {printMsg('Game data was not provided!'); noDataWarned = true;}
        if (!hasLoginInfo() && !noDataWarned) {printMsg('User data was not provided for the command $command' + (action == null ? '' : '/$action') + ' !'); noDataWarned = true;}

        return null;
    }

    static function urlResult(daUrl:Null<Http>, ?onSuccess:() -> Void, ?onFail:() -> Void, ?async:Bool = false, ?customCallback:(?result:Null<Dynamic>) -> Void, ?type:RequestType, ?inviteObject:InviteObject, ?hasCallback:Bool = true):Null<Dynamic>
    {
        var result:Dynamic = '';
        var success:Bool = false;

        if(!async)
        {
            if (daUrl != null)
                {
                    daUrl.onData = function (data:String)
                    {
                        result = Json.parse(data).response;
                        success = result.success == 'true';
                        if (success) {if (onSuccess != null) onSuccess();}
                        else
                        {
                            printMsg(Std.string(result.message));
                            if (onFail != null) onFail();
                        }
                    };
                    daUrl.onError = function (error:String)
                    {
                        printMsg(error);
                        if (onFail != null) onFail();
                    };
                    daUrl.request(false);
                }
            return success ? result : null;
        }
        else
        {
            AsyncHttp.logEnabled = false;
            var request = new HttpRequest({
                url: daUrl.url,
                async: true,
                callback: function(response:HttpResponse){
                    if(hasCallback)
                    {
                        if(type != null) {
                            switch(type) {
                                case USER:
                                    var daJson:Dynamic = response.toJson();
                                    if (daJson != null && daJson.response != null && daJson.response.users != null && daJson.response.users[0] != null)
                                    {
                                        var daFormat:Null<User> = cast daJson.response.users[0];
                                        inviteObject.setInfo(daFormat);
                                    }
                                case INVITE:
                                    callbackGetDesafios(response, customCallback);
                            }
                        } else {
                            /*if(response.content == null)
                                if(hasCallback && customCallback!=null) {
                                    customCallback(null);
                                }
                                return;*/
                            result = response.toJson();
                            if(result==null)
                                return;
                            result = result.response;
                            success = response.toJson().response.success == 'true';

                            //trace(result);

                            if(hasCallback && customCallback!=null) {
                                customCallback(result != null ? success ? result : null : null);
                            }

                            if (success) {if (onSuccess != null) onSuccess();}
                            else
                            {
                                printMsg(Std.string(result.message));
                                if (onFail != null) onFail();
                            }                            
                        }

                    }
                }
            });
            
            request.send();
            return null;
        }
        return result;
    }

    public static function updateStatus(online:Bool = true)
    {
        setData(Std.string(online), myID+"-status", null, null, true);
        trace("novo status: "+getStatus(myID));
    }

    public static function getStatus(id:String):String
    {
        return getData(id+"-status", null, null, true);
    }

    public static function desafiarAmigo(idDele:String, callback:(DataStore)->Void, callbackErrado:()->Void, ?debug:Bool = false)
    {
        var desafios:String = getData(idDele+"-invites", null, null, true);
        var meusDesafios:String = getData(myID+"-invites", null, null, true);
        var jaTem:Bool = false;

        if(!debug)
        {
            for(desafio in desafios.split(","))
                {
                    if(desafio == myID)
                    {
                        jaTem = true;
                        break;
                    }
                }
        
                for(meuDesafio in meusDesafios.split(","))
                {
                    if(meuDesafio == idDele)
                    {
                        jaTem = true;
                        break;
                    }
                }
        }

        if(jaTem) return;
        desafios = desafios!=null && desafios!="" ? desafios+","+myID : myID;
        trace('Invites para o ${idDele}: ${desafios}');
        setData(desafios, idDele+"-invites", callback, callbackErrado, true);
    }

    public static var invites:Array<String> = [];
    public static var canChangeInvites:Bool = true;
    public static function getDesafios(temDesafios:(?result:Null<Dynamic>) -> Void)
    {
        getData(myID+"-invites", null, null, true, true, temDesafios, true);
    }

    private static function callbackGetDesafios(response:HttpResponse, temDesafios:(?result:Null<Dynamic>) -> Void):Void
    {
        if(response.toJson() == null) return;
        invites = Std.string(response.toJson().response.data).split(",");
        if(invites != [] && invites != null)
        {
            temDesafios();
        }
    }

    public static function getUserAsync(id:Int, obj:InviteObject)
    {
        getUserData(id, null, null, true, obj);
    }

    public static function removeInvite(invite:String)
    {
        invites.remove(invite);
        var newDesafios:String = "";
        for(invite in invites)
        {
            newDesafios += invite+",";
        }
        setData(newDesafios, myID+"-invites", null, null, true, true);
    }


    static function getUser():Null<String> {return FlxG.save.data.user;}
    static function getToken():Null<String> {return FlxG.save.data.token;}
}

enum RequestType {
	INVITE;
	USER;
}
