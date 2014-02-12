using UnityEngine;
using System.Collections;

public class DieAfterTime : MonoBehaviour {

	public float deathTime;
	float cooldown;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		cooldown += Time.deltaTime;
		if (cooldown >= deathTime)
		{
			Destroy (this.gameObject);
		}
	}
}
