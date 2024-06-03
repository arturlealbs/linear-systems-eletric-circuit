using Godot;
using System;

public partial class BackEnd : Node
{
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var matrixData = GetNode<MatrixData>("MatrixData");
		matrixData.SetResistor(0, 1.5);
	}
}
