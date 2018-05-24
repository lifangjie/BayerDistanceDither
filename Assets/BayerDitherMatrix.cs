using UnityEngine;
using UnityEngine.Assertions;

public class BayerDitherMatrix :MonoBehaviour{
    private void Start() {
        float[] bayerMatrix = new float[256];
        GenerateBayerDitherMatrix(ref bayerMatrix, 16);
        Shader.SetGlobalFloatArray("bayerMatrix", bayerMatrix);
    }

    private static void GenerateBayerDitherMatrix(ref float[] output, int n) {
        Assert.IsTrue(Mathf.IsPowerOfTwo(n) && n > 1);
        int log2N = Mathf.RoundToInt(Mathf.Log(n, 2));
        int[,] temp = new int[n, n];
        temp[0, 0] = 0;
        temp[0, 1] = 3;
        temp[1, 0] = 2;
        temp[1, 1] = 1;
        int currentSize = 2;
        for (int i = 1; i < log2N; i++) {
            for (int row = 0; row < currentSize; row++) {
                for (int col = 0; col < currentSize; col++) {
                    temp[row, col + currentSize] = temp[row, col] * 4 + 3;
                }
            }
            for (int row = 0; row < currentSize; row++) {
                for (int col = 0; col < currentSize; col++) {
                    temp[row + currentSize, col] = temp[row, col] * 4 + 2;
                }
            }
            for (int row = 0; row < currentSize; row++) {
                for (int col = 0; col < currentSize; col++) {
                    temp[row + currentSize, col + currentSize] = temp[row, col] * 4 + 1;
                }
            }
            for (int row = 0; row < currentSize; row++) {
                for (int col = 0; col < currentSize; col++) {
                    temp[row, col] = temp[row, col] * 4;
                }
            }

            currentSize *= 2;
        }
        for (int i = 0; i < n * n; i++) {
            output[i] = (1f + temp[i / n, i % n]) / (1 + n * n);
        }
    }
}