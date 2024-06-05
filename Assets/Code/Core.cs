using Godot;
using System;

public partial class Core : Node
{
	private MatrixData _matrixData;

	public override void _Ready()
	{
		_matrixData = GetNode<MatrixData>("MatrixData");
	}
	public double[] HandleCircuitUpdateCall(int id, double r, double v)
	{
		_matrixData.SetComponents(id, r, v);

		if (_matrixData.CheckForShortCircuit())
		{
			return null;
		}
		else
		{
			double [][] CoefficientsMatrix = _matrixData.GenerateCoefficientsMatrix();
			double [] ConstantsMatrix = _matrixData.GenerateConstantsMatrix();
			return MatrixSolver.SolveLinearSystem(CoefficientsMatrix, ConstantsMatrix);
		}
	}

	public void AbortCircuitUpdateCall(){
		_matrixData.ReverseModification();
	}
}
