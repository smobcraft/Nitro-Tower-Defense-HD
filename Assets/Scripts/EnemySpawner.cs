using UnityEngine;
using System.Collections;

public class EnemySpawner : MonoBehaviour {

	public float spiderSpawnRate;
	float spiderCD;
	public float venomSpitterSpawnRate;
	float venomSpitterCD;
	public GameObject spider;
	public GameObject venomSpitter;
	public GameObject spawnLoc;
	public float level;

	// Use this for initialization
	void Start () {
		//level = GameObject.Find ("Player").GetComponent<UnitStats> ().level;

	}
	
	// Update is called once per frame
	void Update () {
		spiderCD += Time.deltaTime;
		venomSpitterCD += Time.deltaTime;
		if (spiderCD >= spiderSpawnRate)
		{
			Instantiate(spider, spawnLoc.transform.position, transform.rotation);
			spiderCD = 0;
		}
		if (venomSpitterCD >= venomSpitterSpawnRate && level > 3)
		{
			Instantiate(venomSpitter, spawnLoc.transform.position, transform.rotation);
			venomSpitterCD = 0;
		}
	}

	public void SetSpawnRate()
	{
		for (int i = 1; i < level; i++)
		{
			spiderSpawnRate *= .9f;
			venomSpitterSpawnRate *= .9f;
		}
	}
}
