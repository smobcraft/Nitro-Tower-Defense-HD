using UnityEngine;
using System.Collections;

public class FlameThrowerAttackScript : MonoBehaviour {

	public GameObject currentTarget;
	public GameObject fireLoc;
	public GameObject attackPrefab;
	public float targetRange;
	public float attackRange;
	public float damage;
	public float speed;
	float cooldown;
	string enemyTag;
	public AudioClip fireSound;
	PathfindingScript pfs;
	
	// Use this for initialization
	void Start () {
		if (tag == "Colony")
			enemyTag = "Empire";
		if (tag == "Empire")
			enemyTag = "Colony";
		if (GetComponent<PathfindingScript>() != null)
			pfs = GetComponent<PathfindingScript>();
	}
	
	// Update is called once per frame
	void Update () {
		cooldown += Time.deltaTime;
		if (pfs != null && currentTarget != null)
			pfs.enemyTarget = currentTarget.transform;
		if (currentTarget == null)
		{
			fireLoc.SetActive (false);
			FindTarget();
		}
		else
		{
			if (cooldown >= speed)
			{
				cooldown = 0;
				AudioSource.PlayClipAtPoint (fireSound, Camera.main.transform.position,.7f);
			}
				
			Fire();
		}
	}
	
	void FindTarget()
	{
		Collider[] hits = Physics.OverlapSphere (transform.position, targetRange);
		foreach(Collider hit in hits)
		{
			if (hit.tag == enemyTag)
			{
				currentTarget = hit.gameObject;
			}
		}
	}
	
	void Fire()
	{
		fireLoc.SetActive (true);
	}
}
