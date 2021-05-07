package com.example.flutter_test_app;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.mesibo.api.Mesibo;
import com.mesibo.calls.api.MesiboCall;
import com.mesibo.messaging.MesiboUI;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.lang.reflect.Field;
import java.util.Map.Entry;

public class MainActivity extends FlutterActivity implements Mesibo.ConnectionListener, Mesibo.MessageListener {
    private static final String MESIBO_MESSAGING_CHANNEL = "mesibo.flutter.io/messaging";
    private static final String MESIBO_ACTIVITY_CHANNEL = "mesibo.flutter.io/mesiboEvents";
    private static final String MesiboErrorMessage = "Mesibo has not started yet, Check Credentials";

    EventChannel.EventSink mEventsSink;

    class DemoUser {
        public String token;
        public String name;
        public String address;

        DemoUser(String token, String name, String address) {
            this.token = token;
            this.name = name;
            this.address = address;
        }
    }

    HashMap<String, String> loggedUser;
    ArrayList<HashMap<String, String>> allUsers;

    DemoUser mRemoteUser;
    Mesibo.UserProfile mProfile;
    Mesibo.ReadDbSession mReadSession;

    DemoUser mRemoteUser2;
    Mesibo.UserProfile mProfile2;
    Mesibo.ReadDbSession mReadSession2;

    private String mMessage = null;

    private String remoteUser = "";
    private String[] users = { "Dara", "Richard", "Bo Park", "Ly Setha", "Khun Sopheak", "Toni" };

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), MESIBO_ACTIVITY_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {

                    Mesibo.ConnectionListener messageListener;

                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        mEventsSink = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {

                    }
                });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), MESIBO_MESSAGING_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("loginUser")) {
                        loggedUser = call.argument("loggedUser");
                        allUsers = call.argument("allUsers");
                        String token = loggedUser.get("token");
                        String mail = loggedUser.get("mail");
                        String user = loggedUser.get("loggedUser");
                        DemoUser du = new DemoUser(token, user, mail);
                        mesiboInit(du, allUsers);
                    } else if (call.method.equals("sendMessage")) {
                        mMessage = call.argument("message");
                        String userCalled = call.argument("remoteUser");
                        onSendMessage(null, userCalled);
                    } else if (call.method.equals("audioCall")) {
                        String userCalled = call.argument("remoteUser");
                        onAudioCall(null, userCalled);
                    } else if (call.method.equals("videoCall")) {
                        String userCalled = call.argument("remoteUser");
                        onVideoCall(null, userCalled);
                    } else if (call.method.equals("launchMessagingUI")) {
                        String userCalled = call.argument("remoteUser");
                        onLaunchMessagingUi(null, userCalled);
                    }

                else {
                        result.notImplemented();
                    }

                });

    }

    private void mesiboInit(DemoUser user, ArrayList<HashMap<String, String>> users) {
        Mesibo api = Mesibo.getInstance();
        api.init(getApplicationContext());

        Mesibo.addListener(this);
        // Mesibo.setSecureConnection(true);
        Mesibo.setAccessToken(user.token);
        Mesibo.setDatabase("mydb", 0);
        Mesibo.start();
        for (HashMap<String, String> u : users) {
            String token = u.get("token");
            String mail = u.get("mail");
            String usr = u.get("loggedUser");
            DemoUser remoteUser = new DemoUser(token, usr, mail);

            mProfile = new Mesibo.UserProfile();
            mProfile.address = remoteUser.address;
            mProfile.name = remoteUser.name;
            Mesibo.setUserProfile(mProfile, false);
            Mesibo.setAppInForeground(this, 0, true);
            mReadSession = new Mesibo.ReadDbSession(remoteUser.address, this);
            mReadSession.enableReadReceipt(true);
            mReadSession.read(100);
        }
        MesiboCall.getInstance().init(getApplicationContext());
    }

    // public void onLoginUser1(View view) {
    // mesiboInit(mUser1);
    // }

    // public void onLoginUser2(View view) {
    // mesiboInit(mUser2, mUser1);
    // }

    public void onSendMessage(View view, String user) {
        Mesibo.MessageParams p = new Mesibo.MessageParams();
        p.peer = user;
        p.flag = Mesibo.FLAG_READRECEIPT | Mesibo.FLAG_DELIVERYRECEIPT;

        if (mMessage.isEmpty()) {
            mEventsSink.success("Invalid Message");
            return;
        }

        Mesibo.sendMessage(p, Mesibo.random(), mMessage.toString().trim());
    }

    public void onLaunchMessagingUi(View view, String user) {
        MesiboUI.launchMessageView(this, user, 0);
    }

    public void onAudioCall(View view, String user) {
        MesiboCall.getInstance().callUi(this, user, false);
    }

    public void onVideoCall(View view, String user) {
        MesiboCall.getInstance().callUi(this, user, true);
    }

    @Override
    public void Mesibo_onConnectionStatus(int i) {
        if (i == Mesibo.STATUS_ONLINE) {
            mEventsSink.success("Mesibo Connection Status : Online");
        }
        Log.d("mesibo", "Mesibo_onConnectionStatus: " + i);
    }

    @Override
    public boolean Mesibo_onMessage(Mesibo.MessageParams messageParams, byte[] bytes) {
        String message = "";
        try {
            message = new String(bytes, "UTF-8");

            if (!message.isEmpty())
                mEventsSink.success("Mesibo Message Received : " + message);
            Toast.makeText(this, "" + message, Toast.LENGTH_SHORT).show();
        } catch (Exception e) {
            // return false;
        }
        return false;

    }

    @Override
    public void Mesibo_onMessageStatus(Mesibo.MessageParams messageParams) {

    }

    @Override
    public void Mesibo_onActivity(Mesibo.MessageParams messageParams, int i) {

    }

    @Override
    public void Mesibo_onLocation(Mesibo.MessageParams messageParams, Mesibo.Location location) {

    }

    @Override
    public void Mesibo_onFile(Mesibo.MessageParams messageParams, Mesibo.FileInfo fileInfo) {

    }
}
