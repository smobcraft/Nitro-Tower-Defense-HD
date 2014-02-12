using UnityEngine;
using System.Collections;

public class UnitSpawning : MonoBehaviour {

	public Transform spawnRally;
	public Transform spawnLoc;
	public GameObject nexus;
	public float resources;
	public float maxResources;
	public float collectionRate;

	// Use this for initialization
	void Start () {
		collectionRate = 1;
		resources = 0;
		if (GameObject.Find("Player").tag == "Colony")
		{
			nexus = GameObject.Find("Colony Nexus");
		}
		if (GameObject.Find("Player").tag == "Empire")
		{
			nexus = GameObject.Find("Empire Nexus");
		}
		spawnLoc = nexus.transform.FindChild ("SpawnPosition");
		spawnRally = nexus.transform.FindChild ("SpawnRally");
	}
	
	// Update is called once per frame
	void Update () {
		if (resources <= maxResources)
			resources += Time.deltaTime * collectionRate;
	}

	public void spendResource(float amt)
	{
		resources -= amt;
	}
}
