using UnityEngine;
using System.Collections;

public class SpawnUnit : MonoBehaviour {
	
	public UnitSpawning us;
	public GameObject unit;
	public float unitCost;

	// Use this for initialization
	void Start () {
		us = GameObject.Find ("Player").GetComponent<UnitSpawning> ();
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown(0) && guiTexture.HitTest(Input.mousePosition))
		{
			if (us.resources > unitCost)
			{
				Instantiate(unit, us.spawnLoc.position, Quaternion.identity);
				us.spendResource(unitCost);
			}
		}
	}

	public void SpawnUnitTouch()
	{
		if (us.resources > unitCost)
		{
			Instantiate(unit, us.spawnLoc.position, Quaternion.identity);
			us.spendResource(unitCost);
		}
	}
}
