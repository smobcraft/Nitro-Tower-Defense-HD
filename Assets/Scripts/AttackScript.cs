using UnityEngine;
using System.Collections;

public class AttackScript : MonoBehaviour {

	public GameObject currentTarget;
	public GameObject fireLoc;
	public GameObject attackPrefab;
	public float targetRange;
	public float attackRange;
	public float damage;
	public float speed;
	float cooldown;
	string enemyTag;
	PathfindingScript pfs;
	CharacterController cc;
	public Animator anim;
	public Animation anim2;
	public string walkString;
	public string attackString;
	public AudioClip shotSound;

	// Use this for initialization
	void Start () {
		if (tag == "Colony")
			enemyTag = "Empire";
		if (tag == "Empire")
			enemyTag = "Colony";
		if (GetComponent<PathfindingScript>() != null)
			pfs = GetComponent<PathfindingScript>();
		cooldown = speed/2;
		cc = GetComponent<CharacterController> ();
	}
	
	// Update is called once per frame
	void Update () {
		if (pfs != null && currentTarget != null)
			pfs.enemyTarget = currentTarget.transform;
		if (currentTarget == null)
		{
			if (anim != null)
				anim.SetBool("Attacking", false);
			if (gameObject.name == "Venom Spitter(Clone)" || gameObject.name == "Spider Scout(Clone)")
			{
				if (anim2.IsPlaying(attackString))
				{
					//do nothing
				}
				else
				{
					anim2.Play(walkString);
				}
			}
			FindTarget();
		}
		else
		{
			//we have target, shoot at target
			cooldown += Time.deltaTime;
			if (Vector3.Distance(transform.position, currentTarget.transform.position) >= attackRange)
			{

				try
				{
					Vector3 lookTarget3 = new Vector3(currentTarget.transform.position.x, this.transform.position.y, currentTarget.transform.position.z);
					transform.LookAt(lookTarget3);
					//Quaternion temp = new Quaternion(0,transform.rotation.y, 0,0);
					//transform.rotation = temp;
					cc.Move(transform.forward * pfs.speed * Time.deltaTime);
				}
				catch{}
			}
			else
			{
				if (cooldown >= speed)
				{
					try
					{
						if (gameObject.name == "Venom Spitter(Clone)" || gameObject.name == "Spider Scout(Clone)")
						{
							Debug.Log ("here");
							anim2.Play(attackString);
						}
						Fire();
						Debug.Log ("here2");
						cooldown = 0;
						Debug.Log ("her3");
						if (anim != null)
							anim.SetBool(attackString, true);
						Debug.Log ("here4");
					}
					catch{currentTarget = null;cooldown = 0;}
					
				}
			}
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
		if (shotSound != null)
			AudioSource.PlayClipAtPoint (shotSound, Camera.main.transform.position,.3f);
		if (attackPrefab != null)
		{
			Instantiate(attackPrefab, fireLoc.transform.position, transform.rotation);
		}
		try{currentTarget.GetComponent<Health> ().DealDamage (damage);}
		catch{currentTarget = null;}

	}
}
