// src/template/worker.js

const OAUTH_ACCESS_TOKEN = "ya29.a0AXooCguyPnlMFx16RoYisNafBNEYw3GFGw9d5MXJ_6ky6KYHTqMNFiSALrPnZMZSj5uom5Cq_jgwJ42npt_OQmrR9taiohsmuvXAHN25o7zj-W8w09-grQo7a6-Bzr0h7FwZjeO7rzGMgRh0sm1pE3qvl7CCphAxOv1jaCgYKAQMSARISFQHGX2MiTBMtfe4NZURIS-7gBf6mUA0171"
const TIMEOUT = 60 * 7; //7-Minutes validity from current time

function numericPad(number) {
    return Array(Math.max(2 - String(number).length + 1, 0)).join('0') + number;
}

async function readKVPValue(key, env) {
    const val = await env.defaultKV.get(key);
    let decoded = decodeURI(val).replaceAll('%2C+', ',').replaceAll('%3A+', ':');
    return JSON.parse(decoded.replaceAll('value=', '').split('&')[0]);
}

function getSecondsDifferenceFromDS(ds) {
    const [hours, minutes] = ds.split(':').map(Number);

    const dsDate = new Date();
    dsDate.setHours(hours);
    dsDate.setMinutes(minutes);
    dsDate.setSeconds(0);
    dsDate.setMilliseconds(0);

    let currentTime = new Date();
    var currentOffset = currentTime.getTimezoneOffset();
    var ISTOffset = 330;
    var ISTTime = new Date(currentTime.getTime() + (ISTOffset + currentOffset) * 60000);

    let hDiff = ISTTime.getHours() - dsDate.getHours();
    let mDiff = ISTTime.getMinutes() - dsDate.getMinutes();

    return (hDiff * 60 * 60) + (mDiff * 60);
}


const getISTString = () => {
    var currentTime = new Date();
    var currentOffset = currentTime.getTimezoneOffset();
    var ISTOffset = 330; //ITC Offset
    var ISTTime = new Date(currentTime.getTime() + (ISTOffset + currentOffset) * 60000);
    var hoursIST = ISTTime.getHours()
    var minutesIST = ISTTime.getMinutes()
    return `${numericPad(hoursIST)}:${numericPad(minutesIST)}`
}


const sendPNToEntireRegistry = async (env) => {
    const registry = await readKVPValue('ffpns_registry', env)
    const entries = registry.entries;
    for (let entry of entries) {
        let eT = decodeURIComponent(entry.time);
        let diffInSeconds = getSecondsDifferenceFromDS(eT);
        console.log(`Difference in Seconds -> ${diffInSeconds}`)


        if (diffInSeconds < TIMEOUT && diffInSeconds > 0) {
            console.log('Sending Push Notification:', decodeURIComponent(entry.deviceToken))
            await sendPN(entry);
        }

        // console.log('Sending Push Notification:', decodeURIComponent(entry.deviceToken))
        // await sendPN(entry);
    }
}

const sendPN = async (entity) => {
    const res = await serverSendPushNotification({
        deviceToken: decodeURIComponent(entity.deviceToken).replaceAll('+', ' '),
        content: decodeURIComponent(entity.content).replaceAll('+', ' '),
        title: decodeURIComponent(entity.title).replaceAll('+', ' '),
    })
    console.log(await res.text());
    console.log('PN_TRIGGERED');
}


const serverSendPushNotification = async (reqbod) => {
    console.log("serverSendPushNotification payload", reqbod)
    const response = await fetch("https://fcm.googleapis.com/v1/projects/medical-assistant-923f2/messages:send", {
        method: 'POST',
        headers: {
            "Authorization": `Bearer ${OAUTH_ACCESS_TOKEN}`,
            "Content-Type": "application/json",
        },

        body: JSON.stringify({
            "message": {
                "token": reqbod.deviceToken,
                "notification": {
                    "body": reqbod.content,
                    "title": reqbod.title,
                },
                "android": {
                    "priority": "high",
                    "notification": {
                        "channel_id": "ffpns",
                    },
                },
                "data": reqbod.payload ?? {},
            }
        }),
    })
    console.log('PUSHNOTIF_SENT');
    const res = await response.text();
    console.log(res);

    const modifiedResponse = new Response(res, response);
    modifiedResponse.headers.set('Access-Control-Allow-Origin', '*');
    return modifiedResponse;
}


async function handleScheduled(env) {
    //this occurs on every CRON JOB
    await sendPNToEntireRegistry(env);
}

export default {
    async scheduled(event, env, ctx) {
        ctx.waitUntil(handleScheduled(env));
    },
    async fetch(request, env, ctx) {
        if (request.method === 'OPTIONS') {
            return new Response(null, {
                status: 204,
                headers: {
                    ...request.headers,
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
                }
            });
        }

        if (request.method === 'GET') {
            await sendPNToEntireRegistry(env);
            return new Response(`Sending PushNotifications to all entries active @ ${getISTString()}`, {
                headers: {
                    'Access-Control-Allow-Origin': '*'
                }
            }
            );
        }
        const reqbod = await request.json();
        return await serverSendPushNotification(reqbod);

    }
};