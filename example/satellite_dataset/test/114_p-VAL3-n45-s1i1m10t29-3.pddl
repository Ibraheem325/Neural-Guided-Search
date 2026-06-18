(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	image3 - mode
	thermograph7 - mode
	spectrograph6 - mode
	image4 - mode
	thermograph8 - mode
	infrared1 - mode
	infrared5 - mode
	image2 - mode
	infrared9 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation14 - direction
	Star15 - direction
	Star16 - direction
	Star17 - direction
	Star19 - direction
	GroundStation20 - direction
	Star22 - direction
	Star23 - direction
	GroundStation25 - direction
	Star26 - direction
	Star27 - direction
	Star28 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star4 - direction
	Star13 - direction
	Star18 - direction
	Star24 - direction
	Star21 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Planet31 - direction
	Star32 - direction
)
(:init
	(supports instrument0 spectrograph6)
	(supports instrument0 infrared9)
	(supports instrument0 image2)
	(supports instrument0 infrared5)
	(supports instrument0 infrared1)
	(supports instrument0 thermograph8)
	(supports instrument0 image4)
	(supports instrument0 thermograph7)
	(supports instrument0 image3)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star21)
	(calibration_target instrument0 Star24)
	(calibration_target instrument0 Star18)
	(calibration_target instrument0 Star13)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
)
(:goal (and
	(pointing satellite0 Star4)
	(have_image Phenomenon29 thermograph7)
	(have_image Planet30 thermograph8)
	(have_image Planet31 infrared5)
	(have_image Planet31 infrared1)
	(have_image Planet31 infrared9)
	(have_image Star32 thermograph8)
	(have_image Star32 infrared9)
))

)
