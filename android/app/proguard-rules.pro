# Suppress warnings for TensorFlow Lite GPU delegate
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**