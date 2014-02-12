using UnityEngine;
using System.Collections;

public class Selectable : MonoBehaviour {

	public bool isSelected;
	public MeshRenderer obj;

	void Update()
	{
		if (isSelected)
			obj.enabled = true;
		else
		{
			obj.enabled = false;
		}
	}
}
