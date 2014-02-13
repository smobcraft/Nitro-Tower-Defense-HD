using UnityEngine;
using System.Collections;

public class UpgradeClick : MonoBehaviour {

	public string unit;
	public float amt;
	GameObject player;

	// Use this for initialization
	void Start () {
		player = GameObject.Find ("Player");
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown(0) && guiTexture.HitTest(Input.mousePosition) )
		{
			if (unit == "ss")
			{
				player.GetComponent<UnitStats>().score -= 100f;
				player.GetComponent<UnitStats>().ssDamage+= 1f;
				player.GetComponent<UnitStats>().ssHP += 1f;
			}
			if (unit == "fs")
			{
				player.GetComponent<UnitStats>().score -= 100f;
				player.GetComponent<UnitStats>().fsDamage += 3f;
				player.GetComponent<UnitStats>().fsHP += 2f;
			}
			if (unit == "tank")
			{
				player.GetComponent<UnitStats>().score -= 100f;
				player.GetComponent<UnitStats>().tankDamage += 5f;
				player.GetComponent<UnitStats>().tankHP+= 5f;
			}
		}
	}
}
