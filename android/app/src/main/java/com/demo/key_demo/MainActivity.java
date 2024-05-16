package com.demo.key_demo;

import android.content.Context;
import android.hardware.SensorManager;

import androidx.annotation.NonNull;

import com.belstu.mylib.KeyGenerator;

import java.util.Arrays;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.mylib/key_generator";
    private KeyGenerator keyGenerator;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        new MethodCallHandler() {
                            @Override
                            public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
                                if (call.method.equals("generateKey")) {
                                    SensorManager sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
                                    keyGenerator = new KeyGenerator(sensorManager);
                                    keyGenerator.generateRandomData();
                                    double entropy = keyGenerator.calculateEntropy(keyGenerator.getAccelerometerData());
                                    byte[] key = keyGenerator.generateKey();
                                    result.success(Arrays.toString(key));
                                } else {
                                    result.notImplemented();
                                }
                            }
                        }
                );
    }
}