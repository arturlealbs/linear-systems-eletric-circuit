using Godot;
using System;

public partial class MatrixData: Node
{
	private static readonly double [][] KclCoefficientsEquations = new double[4][]{
	//   			   i1 i2 i3 i4 i5 i6 i7 i8
		new double[] { 1, 1,-1, 0, 0, 0, 0, 0},
		new double[] { 0, 0, 0, 0,-1, 0, 1, 1},
		new double[] {-1, 0, 0, 1, 0, 0, 1, 0},
		new double[] { 0,-1, 0, 0, 0, 1, 0, 1}
	};
	private static readonly double [] KclConstantsEquations = new double[4] {0, 0, 0, 0};

	private double[] lastModification;
	private double [] v = new double[12] {0,0,0,0,0,0,0,0,0,0,0,0};
	private double [] r = new double[12] {0,0,0,0,0,0,0,0,0,0,0,0};

	public void SetComponents(int id, double rValue, double vValue)
	{
		lastModification = new double[] { id, r[id], v[id] };
		v[id] = vValue;
		r[id] = rValue;
	}

	public void ReverseModification(){
		SetComponents((int)lastModification[0], lastModification[1], lastModification[2]);
	}

	public bool CheckForShortCircuit()
	{
		double [][] kvlCoefficientsEquations = GetKvlCoefficientsEquations();

		foreach (var coefficients in kvlCoefficientsEquations)
		{
			bool short_circuit = true;
			foreach (var coefficient in coefficients)
			{
				if (coefficient != 0)
				{
					short_circuit = false;
					break;
				}
			}
			if (short_circuit)
			{
				return true;
			}
		}
		return false;
	}

	public double [][] GenerateCoefficientsMatrix()
	{
		double [][] kvlCoefficientsEquations = GetKvlCoefficientsEquations();

		return new double[][] {
			KclCoefficientsEquations[0],
			KclCoefficientsEquations[1],
			KclCoefficientsEquations[2],
			KclCoefficientsEquations[3],
			kvlCoefficientsEquations[0],
			kvlCoefficientsEquations[1],
			kvlCoefficientsEquations[2],
			kvlCoefficientsEquations[3],
		};
	}

	public double [] GenerateConstantsMatrix()
	{
		double [] kvlConstantsEquations = GetKvlConstantsEquations();

		return new double[] {
			KclConstantsEquations[0],
			KclConstantsEquations[1],
			KclConstantsEquations[2],
			KclConstantsEquations[3],
			kvlConstantsEquations[0],
			kvlConstantsEquations[1],
			kvlConstantsEquations[2],
			kvlConstantsEquations[3],
		};
	}
	
	private double [][] GetKvlCoefficientsEquations()
	{
		return new double[][]{
			new double[] { r[0] + r[1], 0, r[3], r[4], 0, 0, 0, 0}, 								//ABDE: (r0+r1)i1 + r3i3 + r4i4
			new double[] { 0, -(r[5] + r[2]), -r[3], 0, 0, -r[6], 0, 0},  							//BCEF: -(r5 + r2) - r3i3 -r6i6
			new double[] { 0, 0, 0, -r[4], r[9], 0, r[7] + r[8], 0}, 								//DEHG: -r4i4 + r9i5 + (r7+r8)i7
			new double[] { 0, 0, 0, 0,-r[9], r[6], 0, -(r[10] + r[11])}, 							//EFHI: -r9i5 + r6i6 -(r10+r11)i8
			new double[] { r[0] + r[1], -(r[5] + r[2]), 0, r[4], 0, -r[6], 0, 0},					//ACFD: (r0 + r1)i1 -(r5 + r2)i2 - r6i6 + r4i4
			new double[] { 0, 0, 0, -r[4], 0, r[6], r[7] + r[8], -(r[10] + r[11])},					//DFIG: (r7 + r8)i7 -(r10 + r11)i8 - r4i4 + r6i6
			new double[] { r[0] + r[1], 0,  r[3], 0, r[9], 0, r[7] + r[8], 0}, 						//ABHG: (r0 + r1)i1 +(r7 + r8)i7 + r3i3 + r9i5
			new double[] { 0, -(r[5] + r[2]), -r[3], 0, -r[9], 0, 0,  -(r[10] + r[11])},			//BCIH: -(r5 + r2)i2 -(r10 + r11)i8 -r3i3 - r9i5
			new double[] { r[0] + r[1], -(r[5] + r[2]), 0, 0, 0, 0, r[7] + r[8], -(r[10] + r[11])}  //ACIG: (r0 + r1)i1 +(r7 + r8)i7 -(r5 + r2)i2 -(r10 + r11)i8
		};
	}

	private double [] GetKvlConstantsEquations()
	{
		return new double[] {
			 v[0] + v[1] + v[3]  + v[4],								//ABDE: v0 + v1 + v3 + v4		
			 v[2] - v[3] + v[5]  + v[6],   								//BCEF: v2 - v3 + v5 + v6
			 v[7] + v[8] + v[9]  - v[4],  								//DEHG: v7 + v8 + v8 - v4
			-v[6] - v[9] + v[10] + v[11],   							//EFHI: v10 + v11 - v6 - v9
			 v[0] + v[1] + v[2]  + v[4] + v[5]  + v[6], 				//ACFD: v0 + v1 + v2 + v4 + v5 + v6
			-v[4] - v[6] + v[7]  + v[8] + v[10] + v[11], 				//DFIG: v7 + v8 + v10 + v11 - v4 - v6
			 v[0] + v[1] + v[3]  + v[7] + v[8]  + v[9],  				//ABHG: v0 + v1 + v3 + v7 + v8 + v9
			 v[2] - v[3] + v[5]  - v[9] + v[10] + v[11],				//BCIH: v2 - v3 + v5 - v9 + v10 + v11
			 v[0] + v[1] + v[2]  + v[5] + v[7]  + v[8] + v[10] + v[11]  //ACIG: v0 + v1 + v2 + v5 + v7 + v8 + v10 + v11
		};
	}

}
