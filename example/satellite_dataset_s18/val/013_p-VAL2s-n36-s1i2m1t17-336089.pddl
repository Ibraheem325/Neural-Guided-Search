(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation3 - direction
	Star4 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star10 - direction
	Star11 - direction
	Star13 - direction
	Star14 - direction
	GroundStation16 - direction
	Star12 - direction
	GroundStation15 - direction
	Star5 - direction
	Star2 - direction
	Planet17 - direction
	Star18 - direction
	Star19 - direction
	Planet20 - direction
	Planet21 - direction
	Planet22 - direction
	Star23 - direction
	Phenomenon24 - direction
	Planet25 - direction
	Phenomenon26 - direction
	Phenomenon27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Star30 - direction
	Star31 - direction
	Phenomenon32 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 Star12)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(have_image Planet17 image0)
	(have_image Star18 image0)
	(have_image Star19 image0)
	(have_image Planet20 image0)
	(have_image Planet21 image0)
	(have_image Planet22 image0)
	(have_image Star23 image0)
	(have_image Phenomenon24 image0)
	(have_image Planet25 image0)
	(have_image Phenomenon26 image0)
	(have_image Phenomenon27 image0)
	(have_image Star28 image0)
	(have_image Phenomenon29 image0)
	(have_image Star30 image0)
	(have_image Star31 image0)
	(have_image Phenomenon32 image0)
))

)
