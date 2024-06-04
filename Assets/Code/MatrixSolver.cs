using Godot;
using System;

public partial class MatrixSolver: Node
{
	public static double[] SolveLinearSystem(double[][] A, double[] b)
	{
		int n = 8;
		double[][] L = new double[n][];
		double[][] U = new double[n][];
		int[] P = new int[n];

		for (int i = 0; i < n; i++)
		{
			L[i] = new double[n];
			U[i] = new double[n];
			P[i] = i;
		}

		LU_DecompositionWithPivot(A, L, U, P);

		double[] x = SolveLU(L, U, P, b);

		return x;
	}

	static void LU_DecompositionWithPivot(double[][] A, double[][] L, double[][] U, int[] P)
	{
		int n = A.Length;
		for (int i = 0; i < n; i++)
		{
			L[i][i] = 1;
			for (int j = 0; j < n; j++)
			{
				U[i][j] = A[i][j];
			}
		}

		for (int k = 0; k < n; k++)
		{
			int max = k;
			for (int i = k + 1; i < n; i++)
			{
				if (Math.Abs(U[i][k]) > Math.Abs(U[max][k]))
				{
					max = i;
				}
			}

			if (max != k)
			{
				(U[max], U[k]) = (U[k], U[max]);
				(P[max], P[k]) = (P[k], P[max]);

				if (k > 0)
				{
					double[] tempL = new double[k];
					for (int i = 0; i < k; i++) tempL[i] = L[k][i];
					for (int i = 0; i < k; i++) L[k][i] = L[max][i];
					for (int i = 0; i < k; i++) L[max][i] = tempL[i];
				}
			}

			for (int i = k + 1; i < n; i++)
			{
				L[i][k] = U[i][k] / U[k][k];
				for (int j = k; j < n; j++)
				{
					U[i][j] -= L[i][k] * U[k][j];
				}
			}
		}
	}

	static double[] SolveLU(double[][] L, double[][] U, int[] P, double[] b)
	{
		int n = L.Length;
		double[] y = new double[n];
		double[] x = new double[n];
		double[] Pb = new double[n];
		
		for (int i = 0; i < n; i++)
		{
			Pb[i] = b[P[i]];
		}

		for (int i = 0; i < n; i++)
		{
			y[i] = Pb[i];
			for (int j = 0; j < i; j++)
			{
				y[i] -= L[i][j] * y[j];
			}
		}

		for (int i = n - 1; i >= 0; i--)
		{
			x[i] = y[i];
			for (int j = i + 1; j < n; j++)
			{
				x[i] -= U[i][j] * x[j];
			}
			x[i] /= U[i][i];
		}

		return x;
	}
}
